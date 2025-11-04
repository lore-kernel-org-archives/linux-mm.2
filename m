Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDD0CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 19:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2518E0003; Tue,  4 Nov 2025 14:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8720F8E0002; Tue,  4 Nov 2025 14:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7616D8E0003; Tue,  4 Nov 2025 14:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 620468E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:52:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5011C05DF
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:52:40 +0000 (UTC)
X-FDA: 84073972080.22.819B5AD
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1520B20016
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:52:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FHnL5xMj;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762285959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhuUACoe017FfPrBL9Y+3E62APiFcTixj+edYubzRZY=;
	b=I5QqXtmV9FAgmAaWD/I44J6T0f9WbwzR13PHUmJPegoqQBO3PwLTuQkCNlM7MDl1LVRSHF
	QGCjsZ1Ku/IiRDtp1do76ASDFizlGDsUmE6fXc+/Xc3yUNC65RnvMj6bD0EJ3Be+QuBu3l
	5GDCLiC45ucLxhtla/f1dsM4xK3LYXA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FHnL5xMj;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762285959; a=rsa-sha256;
	cv=none;
	b=lsjGlHu0SJBkzClmvd1RxKTk4mI5l20jewabwbYirMDT84B3H99AwVeDpc3Qj1wWSG8TeB
	3IvEXehwRJk3POVTGYR8wnqN8FT7pmfaqT1hOpR1qMgpIcOL9UvWiOghMmR7J6p14gU5R9
	efF/4HTMAW4P3BJuHL/aYBq/iuV5SJA=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ed0d2a949dso40590681cf.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 11:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762285958; x=1762890758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhuUACoe017FfPrBL9Y+3E62APiFcTixj+edYubzRZY=;
        b=FHnL5xMjsz+we3/b0YZSLSss0DU+6DWd6FIV3v21tDapYjlc0pyYLrW/czy8FKHTp5
         RPMHuhcGVYYJlUUs6CJVzHw1JKZVVZsQYnX1xKOXhe1Jq66LlCAwxK6oSuDJ6LJqeZ9e
         n5023nqw66JSjc9vDkWHY64vsLUl0tl5dKNd4xFRLg/QQnLuiYqo8Q0nXDEXy/iCEJe0
         qsFnNBf8EU7po8+I0sI53oOyF9kj52KT1v7wxPJGQIehAI5SuwRywZpAPQUCR9UVcDkl
         9fYw5cKGXpEl3NC5ibDm0mj4N0YC6Pt40m/K7xDKHNcSvg8ZIjNxF1VynWwpwQp5Auxn
         6cVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762285958; x=1762890758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhuUACoe017FfPrBL9Y+3E62APiFcTixj+edYubzRZY=;
        b=QuUSu0Fh4LnqZ/CfSLzOJTXyvmP0INh+27IsPknszTQPopVH0PeUY171vP0hlnVEjq
         luzeRKXdhzLA11aLN1bP77yeaxS2mOLPgltE5Z1ShLmRgtm2EKa4YajbzLIcYuhUpJaF
         EAzkkeXhBK7zeINd26n6HtOFIu9IS6Bq4rDTRVnTP4Liqd188ye/uf3Zwjm/dBL0R2tF
         WvO4V8EovSnoCcGKUzxIMP3zTGyKJFCK7Y5cahxv+nVK85Zrd7874abPT1L7qcHyTeXt
         vKVCM4WM37R30NSprdu1eIr4bwX8PNuVaoMSwaKSNIKFQoaALnOYsPrBmNCu4MK9SoNK
         i/zw==
X-Gm-Message-State: AOJu0Yzyfm5n/g4hJF54mJSpnbpctmyIVtghvpGNL3XE0qff6m/u/aWn
	kst0Crr7aTW/zfpMySRzo6ZpbbeYXSio9oxjGa1QGE99XpumGWC0ZF8SjwuflhyVco4qO1HQIVX
	yKjBxDIxX4JC0+iniFVCZhdWusvDDWbY=
X-Gm-Gg: ASbGncuW8cdL2f/CZPnu6vaW/LzqicZU67Os8nY5wZH+xRrRlTleKHZYTZrB7Kbs9Mz
	CFlxl1NWprT8NKa63eNsSrytvSUroFIK9bO0Je3Q0iZmgHiNlDuBWwaiIxyHSl7r8DoyEleuXPj
	pF6GI5UJy/JecPTOxEb4Hgr8AIjApC/06wbP3M5H/ZeoocJCFLQZV8XZPrhqIS1xEEI2x+eAHc+
	6Tn1htb74gvHCnsDkuezm0xx7+6Ns5kDtJPocsR/8C22OSNk5hhQdz5WwDgr3voihrRaMmaKnDM
	QksIJxtRqbyFd+96
X-Google-Smtp-Source: AGHT+IErS0dFQ9jSDtfrpY3erXURu4B0wJ5JPQIqfYmbvt+/0DnjutNzhFHJ5wyZ+GLxm+MijMOW2D+SuD0mqWz0CIk=
X-Received: by 2002:a05:622a:424d:b0:4c7:130f:72ef with SMTP id
 d75a77b69052e-4ed72347647mr10478241cf.9.1762285957761; Tue, 04 Nov 2025
 11:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-6-3d43f3b6ec32@tencent.com> <CAGsJ_4z1gB8x7GNUL4THdC7G9ZGMqbM3UtWM2LXPoT0xcLAQ3A@mail.gmail.com>
 <CAMgjq7CV14FdHvgGtXwWQPqXKwy4W-5vfR=-hUYkBemeMP=Srw@mail.gmail.com>
In-Reply-To: <CAMgjq7CV14FdHvgGtXwWQPqXKwy4W-5vfR=-hUYkBemeMP=Srw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 5 Nov 2025 03:52:25 +0800
X-Gm-Features: AWmQ_blYiz9VoLZN8wpGXcrjgSu3kDWfO42m1wTALvWOvIpMx5_FNki1QlYNF54
Message-ID: <CAGsJ_4z47L4u50xdv9opC4QN6Jtdx6oR7xVx6WCGCtUa_CqMQQ@mail.gmail.com>
Subject: Re: [PATCH 06/19] mm, swap: free the swap cache after folio is mapped
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1520B20016
X-Stat-Signature: ryumjw6g745apk7iks7iuipwmc5jq5fp
X-Rspam-User: 
X-HE-Tag: 1762285958-937768
X-HE-Meta: U2FsdGVkX18K5avFFMFD2tIkPz9CptuUdcbRqTOXwAxyhtxyNV2gLHyajMyThk+rM1K2GTFeJUwFIrWcA7jrMlig5EQC3tJxjNr++MdmiSut18giBNgQfUS3LfQzJ5QIEXxKePA3oubLgyGg/RzmWM5SUFrxCJ8oWv1ByOm7PAYiiM/2LzXkRqEof3F1JXwQ7S8We3Fcd+s55QufTLLgimROxeZM4HxYDOVQ5wyimDo2i0uGNPURqTjvTN+8CUBuNyoWoAN+h9ZPGlLnKygdw0A/IMuYCxRju2++bNOOsAB2VC00VEhg/Ak9Tc0edq8ruZb3Q4gEvWa6HACoDAgk7exrNmqs/Mrs/B4GUfDyDCfZQKOBvBqOAyUreT3FgpqtjmyUqaSh3ghApxE2+Hy3SStKZu7v0W5vdE7+Gqs0ZCQI4zk5JaA0wbyZbUPMX9jYgmqx6y4N/dHtBsvS4jqjDW4lI+5SbzeRbhCW9rjoVhsZhwOB0t5fP7/ynp7jshmDzy8OvIor66YKkTIxcqOD1PImoVviXVHA1GdxEGOF1H9JUtsGLaH3cDygyqbWPkTMI8skE6+rHmrNAq29P70zZfFo0n4eUi+IYYA3m1jwPsNg7b0N1fYXgQmCka1YS8hgj3fZmvKANyYZiZbk7AGKjfSIxwEZ4az55V6X/xE0bo/nzoBYjwd6BSs/qu2TYbOiYMEwtiTf8vdSJax9vZR35gYw1vGAp8V54weFsN/VekOmwJ+Woz22q+FZjmDdWVaC6F2l24Rw+Wxr9LMCIOhebfP0row+sDoql1/WLjpyG9Ue2tIm7VvjCOuhqcEnrzZoNqEZr8k/I9ZbUEKcbGVdgjhSA4vCfdywfZEV8fKsMwyKTZ2Q0nhfIBu7+QNyecmyM8Pyh9CIBuRjInL3cn/lVsyVaJD+v8AGIFTlXL2MHkjg/jeB6f4pEtVEC0kzS9leVZ/eT6vAPHquVLXm7x0
 Y3+WHdW2
 KA8H2UqlRpMBz6+SjSuWCzJNF+lPA1u2CgdYlxP2nR+QJ0AmH/BS1fhFC910+DsSkwP3wsxFaO2YyCD8LVeBfybVMgD3+Yf0hIhZWMPpPn7xGC2f0v2b4PokukhIhIQoq6WmPVxc8pBAWp7cx0rnJ0T0UzMC9/hiR0Q0XOso/lxmOKAc140oWS40z692NEu7ZNflYVnxtWqMrFY+ttqf8SSr/2wBI8pQZg2ctvgFLkHFc1NDKY+QqigE6vS3zc+hQEHtgZgN07nzjcR+mnFx7Fus6fzDuyZd7MhOHlmryIUC02Auz2sGKnWO1tIbRwiCQIAXiPBYyNNbObxQUu2NDhqHDbQp3Y/G5GgOCsCE/BiO6oZuTgjwm9A1yTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 6:51=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Tue, Nov 4, 2025 at 5:15=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > To prevent repeated faults of parallel swapin of the same PTE, remove
> > > the folio from the swap cache after the folio is mapped. So any user
> > > faulting from the swap PTE should see the folio in the swap cache and
> > > wait on it.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/memory.c | 21 +++++++++++----------
> > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 6c5cd86c4a66..589d6fc3d424 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry=
(struct vm_fault *vmf)
> > >  static inline bool should_try_to_free_swap(struct swap_info_struct *=
si,
> > >                                            struct folio *folio,
> > >                                            struct vm_area_struct *vma=
,
> > > +                                          unsigned int extra_refs,
> > >                                            unsigned int fault_flags)
> > >  {
> > >         if (!folio_test_swapcache(folio))
> > > @@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(stru=
ct swap_info_struct *si,
> > >          * reference only in case it's likely that we'll be the exclu=
sive user.
> > >          */
> > >         return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(fo=
lio) &&
> > > -               folio_ref_count(folio) =3D=3D (1 + folio_nr_pages(fol=
io));
> > > +               folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_=
pages(folio));
> > >  }
> > >
> > >  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
> > > @@ -4935,15 +4936,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >          */
> > >         arch_swap_restore(folio_swap(entry, folio), folio);
> > >
> > > -       /*
> > > -        * Remove the swap entry and conditionally try to free up the=
 swapcache.
> > > -        * We're already holding a reference on the page but haven't =
mapped it
> > > -        * yet.
> > > -        */
> > > -       swap_free_nr(entry, nr_pages);
> > > -       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
> > > -               folio_free_swap(folio);
> > > -
> > >         add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> > >         add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
> > >         pte =3D mk_pte(page, vma->vm_page_prot);
> > > @@ -4997,6 +4989,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >         arch_do_swap_page_nr(vma->vm_mm, vma, address,
> > >                         pte, pte, nr_pages);
> > >
> > > +       /*
> > > +        * Remove the swap entry and conditionally try to free up the
> > > +        * swapcache. Do it after mapping so any raced page fault wil=
l
> > > +        * see the folio in swap cache and wait for us.
> >
> > This seems like the right optimization=E2=80=94it reduces the race wind=
ow where we might
> > allocate a folio, perform the read, and then attempt to map it, only
> > to find after
> > taking the PTL that the PTE has already changed.
> >
> > Although I am not entirely sure that =E2=80=9Cany raced page fault will=
 see the folio in
> > swapcache,=E2=80=9D it seems there could still be cases where a fault o=
ccurs after
> > folio_free_swap(), and thus can=E2=80=99t see the swapcache entry.
> >
> > T1:
> > swap in PF, allocate and add swapcache, map PTE, delete swapcache
> >
> > T2:
> > swap in PF before PTE is changed;
> > ...........................................................;
> > check swapcache after T1 deletes swapcache -> no swapcache found.
>
> Right, that's true. But we will at most only have one repeated fault,
> and the time window is much smaller. T2 will PTE !=3D orig_pte and then
> return just fine.
>
> So this patch is only reducing the race time window for a potentially
> better performance, and this race is basically harmless anyway. I
> think it's good enough.

Right. What I really disagree with is "Do it after mapping so any
raced page fault
will see the folio in swap cache and wait for". It sounds like it
guarantees no race
at all, so I=E2=80=99d rather we change it to something like "reduced race =
window".

Thanks
Barry

