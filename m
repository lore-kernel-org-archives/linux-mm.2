Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 483B0CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 18:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD4B8E0003; Fri, 19 Sep 2025 14:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E378E0001; Fri, 19 Sep 2025 14:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CD08E0003; Fri, 19 Sep 2025 14:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 745888E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:34:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16E0A5AC55
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:34:17 +0000 (UTC)
X-FDA: 83906849754.12.03450AD
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17049140012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:34:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yruqozsW;
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758306855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRfypbk3rW+djPiY0MN9TfRNAsvIt1JInVEAxBCh6KY=;
	b=HAeMD2Tpv24xpVijTfFxk9TDwgMMARHRLw2QIV1BDwhz9RjUl6ez0q7R9X7jKKDGLlMYj/
	2/N0r7xo5xrgImazuGwuly/iGfSWz9/2UbI2rcCG9psoFc3fbzfR1VvtpFbXLfxivhmH/A
	w++q/kEvDkO68Q1vm2MxyZDA+Al3RiY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yruqozsW;
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758306855; a=rsa-sha256;
	cv=none;
	b=Yz2ajIJ+kfb8ukCWF8WN3LyrrJgbH2UAHjFIwYKSwJuAt4VwvMB1MVbcOowcT6ZjI6CADV
	eyzWnwC1b175QKbuFAQGrGVobr4Rqrjq2dtBUB/c17p4MVY/5rxyxQMUoRJk5bggpE0D8B
	930/UR8UuOLvTA1bLq0LsK7eJKdA1pY=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so993a12.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758306853; x=1758911653; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRfypbk3rW+djPiY0MN9TfRNAsvIt1JInVEAxBCh6KY=;
        b=yruqozsWSBmqVQkoJaXFKa33JEPuF3Z+Tbsd15yywst+90nQcfPvOuh9v1ntdFAIac
         FeEnpSj5Le6i+XVurNtsZBiGTqGHhqh4QwRrFs84r2t0owbgbJarH40auCoho9/AAs5K
         yWXDNgSr9KzW4SN8MPpGB0w+20gLYt9hyjhLibydmA/wm7JiFozj4LYeZ+i9dCEcDnqo
         fZDtRIHTyVxD/xv0jb9SPPsWFKis5JdAAgJI1poPh2VtMtQMs+z28OARrQH9rAfEr0fL
         71b3lyg1U7ocOpGU2z5ikHaLKtmHui52hkba4vEjb4cC5y7FqsEPcnxTAe9jaSKuBg2Z
         aMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758306853; x=1758911653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRfypbk3rW+djPiY0MN9TfRNAsvIt1JInVEAxBCh6KY=;
        b=ujGY2aIrYp2IRdXNoUHAg74p4DOUSecvod3i1dZQ8FwVGtwBg7sARHu+ejR3/CnZJK
         YhaqC5NOju/IazgRap4PpTnU7XQvuJA92dxIahhgacW6o526GunL3BrtT5WqC+3/FZMv
         /XULlzCqs5kCOQqnB8aOTSFnG8t2DoMNhh6IaO+bBnLa7exRYe/t75kN2/yZ9oXaXosN
         MGnDslpY1ScU6gFSEDrRNsepnwliXPtSDV2345DltHINCRPNvPH8QhVS3z9Qsxiv1/03
         WyjlDL3tUbAat9L/lArEMfGeE5AN2vDRpQbIKwcX/Pb+0syHjXaqKybSKNgetbuLAP2P
         c2dw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ8UcUz1zgVEmzIqF0ji6aqHdj/4Neb2NZENCdapv9IdPhHz0OLMiSiAbmfV6rkc6xTmVfu1Xx/w==@kvack.org
X-Gm-Message-State: AOJu0YwMuWbZkg5R5blmsKY5/cG8JMa7KQZFkI3ptp56/tTsl7s3Qvp6
	5yz2NNA9xMHFAY5sE15Ip7z+57vAog9kh5F/yGLvmo5YKgZ2dcUXMB/iieKPP+3TjeMRC/Dbd/e
	T0Zv/r0v0F9LsqD2F34Qx75L6F1DOvkGi37ry/Qsg
X-Gm-Gg: ASbGncsEYaLGa6iiY+aM3354uDxpckUsvWZpPFB0sG47fPEb008tUU1wFGM6OKB46jE
	cq2HeYx8K5bAFUnqqMyIyMnEzCs58F2AiTEzQihoMMq4QDhC9kh5Rc+cS8Dl8nRP/7DAfpZWsbU
	5izAuQrzASEgPMxJCCw6nXeMVmmQUe64ORUkg0uZF/HFRtwJBwmIjyVIlohcN4h7YfF1O7iSl5c
	kJ8mxhL1LOve8iHZXRsRF1nU1OOta76QW2LFQ==
X-Google-Smtp-Source: AGHT+IHX9xSXtA79S5eGRCC3SFmgSu/0rTqb3w9Jv9X+GHpZqs0QN8D3FBgaC1nwVtOoHH/Hmc/AggI002X5UFini68=
X-Received: by 2002:a05:6402:4303:b0:62e:e7b4:a9a3 with SMTP id
 4fb4d7f45d1cf-62f7e10b0abmr249063a12.2.1758306853255; Fri, 19 Sep 2025
 11:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-3-lokeshgidra@google.com> <4e4bee5c-c2d9-4467-b7b8-d3586a5cd6e4@lucifer.local>
 <CA+EESO6B04FQ9pxmf6n1Up+r-a4yGYO6N_HakiYj0hLVvhs2ig@mail.gmail.com> <e8fcbb82-9029-456f-a5c1-eb5cf4b05ba3@lucifer.local>
In-Reply-To: <e8fcbb82-9029-456f-a5c1-eb5cf4b05ba3@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 19 Sep 2025 11:34:01 -0700
X-Gm-Features: AS18NWAfcSutEqupr05buJ6Nm2787057_jp_rKHHX2qiuq8lAQNCniHjw3qphVQ
Message-ID: <CA+EESO7b0HvYCDTqPdhe5Oq5xo1YdGQjW=pCRzyX+8Yi0dfJGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, David Hildenbrand <david@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 17049140012
X-Stat-Signature: 3fa8budcksuh3hf98efw7qonqah7aooo
X-HE-Tag: 1758306854-635319
X-HE-Meta: U2FsdGVkX1+fanjUzQy4bXlgDVc512dz1rpuyM1jsbHWBTROFKmxO/Hkm+mVIy9pejZVP+jr8FcfcDLhjKZ6bn/83kdCZVMiiA2ayJ26h2ooKR7+xgJ/qfzgCBrgDGUXQGx8KOOGGL8x3r584PT5liO++jtopK19dDSeB2eve2SCQ0CnckH3YkObsm0zjt7WV91/9Sq2cfO31vGW0OIMitJ+Z05JYi70Yamrj2s42aF4bl3mAbrqTjjYIE7zRsFCvcGlYB6E2LFwVHX+SWh4B8bo/JB/vTkcNRgAg3d+tm64ZnRzdZiGI4JbwLvWVfDdKeRfDEj/yt4Jpry2qo2KfrhXFPOHwwuKisCYsUotzy/XV6RHMN+b6P+48Cf+1cglf/WGGgbz2PTHmOh72bX7GszBY94L5Y/k63waRyoglUvH5LpAQbM8YgDiRhsOQrtGUSAb+ZR2OPWwtYHcBx9ZvPzGAR/izhzEFMxVWlbAVo8BKsoViNqB8bApWAJpScnxlSZJu3o41zhacebGFus1Sdv1ChCwJrlXHTxRKYRQZf3XYDZJl1fRQBjDmF0yenvZUuZGKehvhf6ZV2kKAfaffz5OeGHIFZQhmGvvBXJ5SrsfavFMmJCS7BhD0/4hRGW+ELqBBmzY3qEwDRMBENQHMFV9L2mr8j52rF9dXdaJ454CGhJ9BQDKI2D/8UiuZGSUhWhIWahkRIjv9hy7gD4obDFWMlqhCZJAFqTFuWEbJi9o1MIixbzD5BgAo5w/rgdBKqXSTTpaVKSbU9XgPkmGLtF7vG900KjM70+hbCyb28hN9wcfWvZ1YY6emgC+XQn2bq82QPoXdYsVmt0d3PmAznIqlBy5st+N8Xl+6Bwb/w2Z8rOj9RCE5TSGjNltIqCKlA7FyihXA9eD9KBXmYiA6GBTiu3SLf9AvxUoZRa6rb8C8MgaoHX6FH6eaz0RJH4OnzcENaZhaeLX1lkLZmc
 y0Qt6Qp2
 soYwaKOSNduoQEQZmgmErb2JGIqqXunc8HQXBhWH3XD+wxHQjv741ImCJDQkVeiMDDhdvZ8T3pcoSI4Xm91xSINJuOOfA2+C6/4n1v0cxLFgeJoxZ9Cz5pxKlKzPuSgevM07pRtM4MDosaemZ9ZBdJRFh/d8R/JJgOkwSgkXceGfybwRZD4d0AGBzSLs67D4gdh0viQazF85SAiaKMTecEU4JHnC72AnHxDRJNRXy/+E2Vv5Yv8Mk4+ihiAeoSUw2e9MGSfNbpd/WXu1PN+d6EcxZvg4QccrPQC0NodsYxsvejl3vqHBbkDNbAu8F9eTg0nZJ+nipEXnBiz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 2:58=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 18, 2025 at 11:30:48PM -0700, Lokesh Gidra wrote:
> > On Thu, Sep 18, 2025 at 5:38=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Sep 17, 2025 at 10:51:35PM -0700, Lokesh Gidra wrote:
> > > > Now that rmap_walk() is guaranteed to be called with the folio lock
> > > > held, we can stop serializing on the src VMA anon_vma lock when mov=
ing
> > > > an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl=
.
> > > >
> > > > When moving a folio, we modify folio->mapping through
> > > > folio_move_anon_rmap() and adjust folio->index accordingly. Doing t=
hat
> > > > while we could have concurrent RMAP walks would be dangerous. There=
fore,
> > > > to avoid that, we had to acquire anon_vma of src VMA in write-mode.=
 That
> > > > meant that when multiple threads called UFFDIO_MOVE concurrently on
> > > > distinct pages of the same src VMA, they would serialize on it, hur=
ting
> > > > scalability.
> > > >
> > > > In addition to avoiding the scalability bottleneck, this patch also
> > > > simplifies the complicated lock dance that UFFDIO_MOVE has to go th=
rough
> > > > between RCU, folio-lock, ptl, and anon_vma.
> > > >
> > > > folio_move_anon_rmap() already enforces that the folio is locked. S=
o
> > > > when we have the folio locked we can no longer race with concurrent
> > > > rmap_walk() as used by folio_referenced() and hence the anon_vma lo=
ck
> > >
> > > And other rmap callers right?
> > Right. Will fix it in the next version.
>
> Thanks!
>
> > >
> > > > is no longer required.
> > > >
> > > > Note that this handling is now the same as for other
> > > > folio_move_anon_rmap() users that also do not hold the anon_vma loc=
k --
> > > > namely COW reuse handling. These users never required the anon_vma =
lock
> > > > as they are only moving the anon VMA closer to the anon_vma leaf of=
 the
> > > > VMA, for example, from an anon_vma root to a leaf of that root. rma=
p
> > > > walks were always able to tolerate that scenario.
> > >
> > > Which users?
> >
> > The COW reusers, namely:
> > do_wp_page()->wp_can_reuse_anon_folio()
> > do_huge_pmd_wp_page()
> > hugetlb_wp()
>
> Right let's put this in the commit message is what I mean :)
>
> >
> > >
> > > >
> > > > CC: David Hildenbrand <david@redhat.com>
> > > > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > CC: Peter Xu <peterx@redhat.com>
> > > > CC: Suren Baghdasaryan <surenb@google.com>
> > > > CC: Barry Song <baohua@kernel.org>
> > > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > > ---
> > > >  mm/huge_memory.c | 22 +----------------
> > > >  mm/userfaultfd.c | 62 +++++++++-----------------------------------=
----
> > > >  2 files changed, 12 insertions(+), 72 deletions(-)
> > > >
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 5acca24bbabb..f444c142a8be 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd, pm
> > > >       pmd_t _dst_pmd, src_pmdval;
> > > >       struct page *src_page;
> > > >       struct folio *src_folio;
> > > > -     struct anon_vma *src_anon_vma;
> > > >       spinlock_t *src_ptl, *dst_ptl;
> > > >       pgtable_t src_pgtable;
> > > >       struct mmu_notifier_range range;
> > > > @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm=
, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> > > >                               src_addr + HPAGE_PMD_SIZE);
> > > >       mmu_notifier_invalidate_range_start(&range);
> > > >
> > > > -     if (src_folio) {
> > > > +     if (src_folio)
> > > >               folio_lock(src_folio);
> > > >
> > > > -             /*
> > > > -              * split_huge_page walks the anon_vma chain without t=
he page
> > > > -              * lock. Serialize against it with the anon_vma lock,=
 the page
> > > > -              * lock is not enough.
> > > > -              */
> > > > -             src_anon_vma =3D folio_get_anon_vma(src_folio);
> > > > -             if (!src_anon_vma) {
> > > > -                     err =3D -EAGAIN;
> > > > -                     goto unlock_folio;
> > > > -             }
> > > > -             anon_vma_lock_write(src_anon_vma);
> > > > -     } else
> > > > -             src_anon_vma =3D NULL;
> > > > -
> > >
> > > Hmm this seems an odd thing to include in the uffd change. Why not ju=
st include
> > > it in the last commit or as a separate commit?
>
> You're changing move_pages_huge_pmd() here in a change that's about the u=
ffd
> change, seems unrelated no?

This function is a part of UFFDIO_MOVE only :) It handles the
huge-page case of UFFDIO_MOVE and there are no other callers. But let
me know if you would like this in a separate patch.
>
> >
> > I'm not sure I follow. What am I including here?
> >
> > BTW, IMHO, the comment is wrong here. folio split code already
> > acquires folio lock. The anon_vma lock is required here for the same
> > reason as non-large page case - to avoid concurrent rmap walks.
>
> This is called via split_huge_page() used by KMS and memory failure, not =
the
> usual folio split logic afaict.
>
> But those callers all take the folio look afaict :)
Sorry, yes that's what I meant. The real issue here also is
rmap_walk() because of which anon_vma lock was required and not what
is mentioned in the comment.
>
> So yeah the comment is wrong it seems!

