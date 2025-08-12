Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3D5CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C130D8E015F; Tue, 12 Aug 2025 11:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB1A8E00B0; Tue, 12 Aug 2025 11:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02158E015F; Tue, 12 Aug 2025 11:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A22798E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:50:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D8A41403A1
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:50:50 +0000 (UTC)
X-FDA: 83768543460.17.B936E17
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57B294000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:50:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=puavb2om;
	spf=pass (imf12.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755013848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCoZwKFBupR3itwaM4Skw0t8VDfdsrBMsPZ/C5dezKg=;
	b=xUH16VEvqQp6K59ErqHgP7/fn9blIGS4OQULzAeo/EmU9sy4vSdC+II/insA8Q6C1tnKDV
	IvJ+pEzTre39KpXJfuumH1+TWxLrsJrjVCfsEXo755L8CyvPwlIU4/qiuWb+SgfDkmXU+D
	ZzwIQo9XQ8oS/Bc2/YRqUazGG//UvFM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=puavb2om;
	spf=pass (imf12.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755013848; a=rsa-sha256;
	cv=none;
	b=HkzeAfKN22rJKz6iL6YVuBnctf27zutPDCgO5RbfWUqBEeHofoO7Dp5PdnZV8WOIu18gkp
	PKCuahlbx+vlV4flv5O08aUztEuiB2L+2bj64tsfsBIaCDV/NvSv+WAi7su1hSf5bqgq3X
	Mf3FqhIatbhO2GOOaL7JeioBz9DVC7Q=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso2393a12.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755013847; x=1755618647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCoZwKFBupR3itwaM4Skw0t8VDfdsrBMsPZ/C5dezKg=;
        b=puavb2omOX8Wb/8h/42ZFcO7+Yhn2SAMrXLuuAWzG+64N/fwcWU7HbIx9AanVymM8R
         ypXVPPxoYVEI8wdjehVC6sXbkWRq/8K9ZNApi9U+TZJGnudvXYzIbrtEB1I5uIV4vm5O
         MzYvt60nCeL2X2y11FrRdaUCEXnE+H+Y1GabdWEtcDRqx5PMtUoyx7frz2XXPmdAKwmK
         wDjArWPLlZ6wo2gT1WhcjP9+snBISXldxZxKt0R5M/h4cDKCHYKpAHPNcf9TcNpvN4yq
         1FRaTMH8gAuGDrwHFH93VPOoddHIStAks3T5aLUa5l/txdeibfjIh77pP53dcEaK57Zg
         h1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013847; x=1755618647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCoZwKFBupR3itwaM4Skw0t8VDfdsrBMsPZ/C5dezKg=;
        b=dCAE8d3aDrxYdvgcH74xP8XRE2eb8+ufUnCHoNJ+6qyQbRfwzLEqChdy86AL9Hgheo
         aIWVhLFcAwteN1OfA0QCBiqoK2ZVHwEhwGNNPeqv7pXACCkDLSKrz0pOHX4B1PDnLSBF
         TKO1hfbHE7GhqwpqYI1fbZ3j5U3AqWu7vaHy9e3lFKwCJRNG1OfkngL6x8CduF9bexU1
         lfx7lxTqjcT70qfJyU8N7VjCroFZE3umYH6ZfGob6TQCaE3zR0ODIf8aQXTivzwksn7x
         Vd8omLcXE3U+SVr1OUA2d1mc79TaipBUDM6FVf4yiCfHdphpGZQx3YqLq2y+YT4NT1BR
         ffiA==
X-Forwarded-Encrypted: i=1; AJvYcCXZXO12m9bHrLC5unqZirKVUXEpBEEw0sTGpyIo9W8zQHYwWae4tEJ3WbUy5VhnemKWDRdoS8ZGrw==@kvack.org
X-Gm-Message-State: AOJu0YyHv74NlhFo6uwA1yWqD83sUxB2fgjT3r7aXC4hHF/YCDBZ0Rq9
	1qXaXezrLBg6SJu3H5RkNtwGXty8UdJ1DA9ZFNCaEQfNQtBzu/tsiKH/rvHsJENEW/ZGOLwlYNh
	TqoV9U3E97rPbgYd8oRBeFAl0WkjM8uEBy0ga1HXE
X-Gm-Gg: ASbGnctvQnHHVfumexyz5Ua9KY8KU49oYrZ8X+RiuW6lMcVxV70aF7KOgiExItDHrSu
	wvOASRFJieeqE8oRLwT8+5QOGD8ENpcLAuu8ow1A7q0pirG8mrYlstjXBhyhDWz63VelUSJLnEy
	X0Ud1PFKjE/9fvpg9DNEc+2xOp44jeCsJdt56vrYICJ0uwcZ7Mkd4hY2VvZ+UbDs1SGtAM4Abp8
	2UYiRDPhN+IDpYJYNA2qeLBR1NYquV4g36gWCp3
X-Google-Smtp-Source: AGHT+IEBJS+zJytE4LlBAX817PjNBbaQW+x370NQ4pBuN1Wk/0tDNwVb6chku+jMLsgNio0Ll/QZIxrFYt0bYXx0JBs=
X-Received: by 2002:aa7:d491:0:b0:618:1799:5baa with SMTP id
 4fb4d7f45d1cf-618517ce884mr81533a12.7.1755013846547; Tue, 12 Aug 2025
 08:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com> <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 12 Aug 2025 08:50:34 -0700
X-Gm-Features: Ac12FXyCf9Toynyp6Mriq0P668p_pyrHqsgpxbzBfKDhOkLtScB0l-B649WZ7-I
Message-ID: <CA+EESO4JFCR5P9PFoY2zo+X1Y-qv+-yy8X887isoqXwfQBtn1Q@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 57B294000B
X-Rspamd-Server: rspam06
X-Stat-Signature: tbgs4t5j5xe1r7czseawdzhz9wn1bcue
X-HE-Tag: 1755013848-655298
X-HE-Meta: U2FsdGVkX1+UXfCcrcnEoEWcpXJz7ry4ddZu1PEJxuzsLKvbodFOjRmdfZIi3sIc4T3vqSgNRgkogQpmGpmYMdOzrMdSfb1kjJnZS6v3zJSlhFjtpU01V9w3/uHP8dLgYli/TCrIsflVT+gWam9Tqib/zxHGocxBPzgp4IWgLdWrBzDvplkFPRrBPe4vN9NpRgHInz6atx1zUCo2E0w1R7SWBq5TfqHvLTGVOj+IYGn5bK3YC4uvrLU21mdGciNyWh4Jw/oMEUdeNin10/uoCjlc9znAveqSafrnp2EhpDGisKxKbxxoD9JZlqvrvT/KeB/NaEGlsXc++HMuLJo9x2Nd9PFwGFSS+S8m+91NDevmJ48U7uwOO2/kOdcGxVgFeupuJDZ2ZVs9FLktb/EQ0od3OGNgDDm+dInxoLC8rakHnzwyIYNL9w7rYfZjRZJN4pzJ4R/ZFaHzLadp9MfEEGi/0PUaO9rGU2EX9iVOaFG4Q8VKa+2deLpxV0LIXQVKQ6hXkTOmfT4fIWD0itbUoqXxearSl0tOSh5HWwKnGl4LMoJB8lFU6O+1kYuSLxwrAdMtyU6axS6zH+b+oR0IN3b6eM4qgMhegNlwqiTTrXpEzlzpcSrWoUK0JMNY29g9QKa5PL/f/wpfX7BNIjjOY6Bko+Vp2eG7ixz13JBd1s9r+9n4aTGDasGn0cxmPW24zf3kCCfRy8XtyHzHB9rf+jdFT5+XZWMSzTw/j+kRThNRc42z8BO+tMrLa+dRaPRQK4qMAVOm++C+exFdlQdSHKV7gue1BVah46madG6adA16fLrXIxOdWsNHrEvevqh34ji2g3ozxPXajHm0CI5mtM29/tOPS348p6TAcVksDc3q0ZcyNkNcjqbYTipIrhTjw7up/NXXmvfyPMfe+K3nGlooc9VCngOlgUQeAq0TkqqB54pLNopgGBb/UxRfB97giur3MTUKgRpYImiyYl3
 izQWHkiL
 8DoBe1yM9H5cf8EEDtQ36o3uLU6vjdweCIv68R80kxyZjpbi/+POFE0sh01lrhvZWNFhe6TF2f9SEeedBfsf2knU+mhaZb2jOlptohfTQPwGx+sZe12EOMOeLSDdtXa5mjz/6noIzeuIwv5NEfrTTf4ucJMNkCHdOYqTK922wBddQF2h8XH46zPupmUvcK1xStlyfkFvc1VjK3QjfgbEbHYrvikGiKcqZ0ZII7nmAw4d1XL60UaSf25RTZfdDjS+b4iN0tpLv21JKo2oWBZUM24C2WM4fkb2/6l9LEjIRru1pzSvulasjtYx13SCqXUv/VFCZ+BTrYqeyRYNd66dy7V7kqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 8:55=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> Hi Lokesh,
>
>
> On Sun, Aug 10, 2025 at 2:29=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> > Changes since v3 [1]
> > - Fix unintialized 'step_size' warning, per Dan Carpenter
> > - Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
> > - Removed flush_cache_range() in zero-page case, per Peter Xu
> > - Added comment to explain why folio reference for batched pages is not
> >   required, per Peter Xu
> > - Use MIN() in calculation of largest extent that can be batched under
> >   the same src and dst PTLs, per Peter Xu
> > - Release first folio's reference in move_present_ptes(), per Peter Xu
> >
> > Changes since v2 [2]
> > - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> > - Added check to ensure all batched pages share the same anon_vma
> >
> > Changes since v1 [3]
> > - Removed flush_tlb_batched_pending(), per Barry Song
> > - Unified single and multi page case, per Barry Song
> >
> > [1] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@go=
ogle.com/
> > [2] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@go=
ogle.com/
> > [3] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@goo=
gle.com/
> >
> >  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 127 insertions(+), 51 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..39d81d2972db 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *d=
st_pte, pte_t *src_pte,
> >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> >  }
> >
> > -static int move_present_pte(struct mm_struct *mm,
> > -                           struct vm_area_struct *dst_vma,
> > -                           struct vm_area_struct *src_vma,
> > -                           unsigned long dst_addr, unsigned long src_a=
ddr,
> > -                           pte_t *dst_pte, pte_t *src_pte,
> > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > -                           struct folio *src_folio)
> > +/*
> > + * Checks if the two ptes and the corresponding folio are eligible for=
 batched
> > + * move. If so, then returns pointer to the locked folio. Otherwise, r=
eturns NULL.
> > + *
> > + * NOTE: folio's reference is not required as the whole operation is w=
ithin
> > + * PTL's critical section.
> > + */
> > +static struct folio *check_ptes_for_batched_move(struct vm_area_struct=
 *src_vma,
> > +                                                unsigned long src_addr=
,
> > +                                                pte_t *src_pte, pte_t =
*dst_pte,
> > +                                                struct anon_vma *src_a=
non_vma)
> > +{
> > +       pte_t orig_dst_pte, orig_src_pte;
> > +       struct folio *folio;
> > +
> > +       orig_dst_pte =3D ptep_get(dst_pte);
> > +       if (!pte_none(orig_dst_pte))
> > +               return NULL;
> > +
> > +       orig_src_pte =3D ptep_get(src_pte);
> > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_=
pte)))
> > +               return NULL;
> > +
> > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > +       if (!folio || !folio_trylock(folio))
> > +               return NULL;
> > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)=
 ||
> > +           folio_anon_vma(folio) !=3D src_anon_vma) {
> > +               folio_unlock(folio);
> > +               return NULL;
> > +       }
> > +       return folio;
> > +}
> > +
>
> I=E2=80=99m still quite confused by the code. Before move_present_ptes(),=
 we=E2=80=99ve
> already performed all the checks=E2=80=94pte_same(), vm_normal_folio(),
> folio_trylock(), folio_test_large(), folio_get_anon_vma(),
> and anon_vma_lock_write()=E2=80=94at least for the first PTE. Now we=E2=
=80=99re
> duplicating them again for all PTEs. Does this mean we=E2=80=99re doing t=
hose
> operations for the first PTE twice? It feels like the old non-batch check
> code should be removed?
>
> > +static long move_present_ptes(struct mm_struct *mm,
> > +                             struct vm_area_struct *dst_vma,
> > +                             struct vm_area_struct *src_vma,
> > +                             unsigned long dst_addr, unsigned long src=
_addr,
> > +                             pte_t *dst_pte, pte_t *src_pte,
> > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > +                             struct folio **first_src_folio, unsigned =
long len,
> > +                             struct anon_vma *src_anon_vma)
> >  {
> >         int err =3D 0;
> > +       struct folio *src_folio =3D *first_src_folio;
> > +       unsigned long src_start =3D src_addr;
> > +       unsigned long addr_end;
> > +
> > +       if (len > PAGE_SIZE) {
> > +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > +               len =3D MIN(addr_end - dst_addr, len);
> >
> > +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > +               len =3D MIN(addr_end - src_addr, len);
> > +       }
>
> We already have a pmd_addr_end() helper=E2=80=94can we reuse it?
>
> [...]
>
> >         /*
> > @@ -1257,7 +1327,7 @@ static int move_pages_pte(struct mm_struct *mm, p=
md_t *dst_pmd, pmd_t *src_pmd,
> >                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
> >                         err =3D -ENOENT;
> >                 else /* nothing to do to move a hole */
> > -                       err =3D 0;
> > +                       err =3D PAGE_SIZE;
>
> To be honest, I find `err =3D PAGE_SIZE` quite odd :-) Could we refine th=
e
> code to make it more readable?
>
Agreed! I'll replace 'err' with 'ret' as the function no longer only
returns error but also bytes-moved if there is no error.

> [...]
>
> > @@ -1857,10 +1930,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >                                 break;
> >                         }
> >
> > -                       err =3D move_pages_pte(mm, dst_pmd, src_pmd,
> > -                                            dst_vma, src_vma,
> > -                                            dst_addr, src_addr, mode);
> > -                       step_size =3D PAGE_SIZE;
> > +                       ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> > +                                             dst_vma, src_vma, dst_add=
r,
> > +                                             src_addr, src_end - src_a=
ddr, mode);
> > +                       if (ret < 0)
> > +                               err =3D ret;
> > +                       else
> > +                               step_size =3D ret;
>
> also looks a bit strange :-)

Any suggestions on how to improve this? 'step_size' is expected to be
different in each iteration of the loop even without this patch.
>
> >                 }
> >
> >                 cond_resched();
> >
> > base-commit: 561c80369df0733ba0574882a1635287b20f9de2
> > --
> > 2.50.1.703.g449372360f-goog
> >
>
> Thanks
> Barry

