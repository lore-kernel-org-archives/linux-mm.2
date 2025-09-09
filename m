Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0582CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D5B6B0028; Tue,  9 Sep 2025 10:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E226B0029; Tue,  9 Sep 2025 10:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B468E0003; Tue,  9 Sep 2025 10:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15AAE6B0028
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:55:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F7511A506
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:55:00 +0000 (UTC)
X-FDA: 83870009160.04.DD7E2AD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE685A0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:54:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GN822gCs;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GWXE+3wBOcPt7oKnTkYOal1ucKO7Pnm2lZVyHLTocM=;
	b=jsaMDhxlOqnVNYS2pIZwQ1cr4gMHcMkXxAs5yEOyrTuuUowMEa+ymbv7/5qNHUHSu3XYmA
	clOEsZxT0tBMazunJF6HiwYfH0WAyntRBkXiF7ZGkww7/723aMhwGhlTK94AFBTbAMdp1i
	vnP2Ot6qx0FkSqnlwevPFf9eJH3wkk8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GN822gCs;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429698; a=rsa-sha256;
	cv=none;
	b=8WzZjT2KEk63o9SKmuOXqrfyQEb4dcL9Ej/gkJkG8qVrj9TJ/d42pm5Lofmdlq3zEKIQsl
	CZp7fyEnKkjRJLS27V/IUYaUwy0BBamndr4sAvINJPgTZl/l0BuvfvNee37vGmg66g/xQV
	MuJPCLm65uFlgtM8oMJkcuF8w7jla6Y=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-624fdf51b44so3484134a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757429697; x=1758034497; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GWXE+3wBOcPt7oKnTkYOal1ucKO7Pnm2lZVyHLTocM=;
        b=GN822gCsjQN/ZH+RqOoa0Z4bJ3pUPMPdyy5WUrZy9RmuYl5E7FtuhtyoRK8x3AZIQP
         LY+YVaWNcaaA9UFt4AsPaqemK35kvcT+GE3S6m2kI307GAMSfP+wdg5GedqL0Javb0Sa
         VR9nUwK+Eu8EgiuQx7mnOpT1EgY8TDCoE/gPBncta3FOOAACZlIivcCTbzJ3q9Jk3h5u
         jmT89mq5kbOuot8Hh87JTT6wh/UowSkgQeUM8/65NwridPjzdG4w+BNrQhSIesdQU56x
         aODCnE+aqJx0Wtc0zPbIx8eweyVDdwP0BQHCeoFKpdNzeZhFH2iEkXQaI36bJxEvdS42
         V1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429697; x=1758034497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2GWXE+3wBOcPt7oKnTkYOal1ucKO7Pnm2lZVyHLTocM=;
        b=YkGE5sywnEuJVAu/3IZXec4jRXO++JLPkY+6px881l3KwiXxlflAWM/4RM5978itt8
         0wPvAemdZGCqtAQU4sHGED/oInoH/ZvEw632gmRxuSVJdC53XgenNo4yo1d4GUTPSEFG
         ffmBW31GaQLPd2EDkqO/e+LgWhR5DucLHTGeuV984InPn3SL4ELkBXP/ZwPsI4nC8HAv
         jDbfVbBq2cnB/1gtDNH8sIlmQiilvnFzlnwqw4zZeFuOI3Z05AjUPL4TqalPAeiskwz6
         sTEQn/7FSyAkIVL0pFe6aL0jgT3eue4CYPaWup+gjJRCi1jirkHCPHYXBVRnx5LWA0sp
         92GQ==
X-Gm-Message-State: AOJu0YwlScnof7bFntu2bCafKtldEunMCCMQWDnouc4b9IY3K5ytVxD5
	Va8qYwVfv7ekAsW/oAx2EM4R5sf2H6Bp3fSK1ZR5rjCBdWZA8ne4GKdkm0LXemLnmYB/a+RfEbD
	i2zdVjtYaFqakDv8ubDuvYzMWOQGCWTU=
X-Gm-Gg: ASbGnctw5C8s8Mu98HEDQKRJexe8tqz23r7PnCQS/K6zhEhyqvYqHM0hwjIMVtYcFed
	yukq58eM5rxGSZIR/c7xTpME8jPwtTBoKFlm7UmPYe5Veq0ILto0WKS2pltYuF6h40ZBwoGoxVO
	loAkOp4UsINfbSt1ikaI9B3T/ehkSMJd/rvoQBTqL3fZHHcJgmme45wAxVwVVJt1LQ08K51EpeU
	Y4y0NBHcdK3/MePT798sQ==
X-Google-Smtp-Source: AGHT+IEMt+u1ClOjcV2n5CQ17ZjrpPmx/eiarEJGhF0xznnFrQSXo9j9Ba6/99ZFdT4zmW929GCRlOqIyVzGOUfqDZQ=
X-Received: by 2002:a05:6402:23ce:b0:621:99dc:8cea with SMTP id
 4fb4d7f45d1cf-6237cdccd25mr9687939a12.37.1757429697063; Tue, 09 Sep 2025
 07:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-5-ryncsn@gmail.com>
 <bd8338cf-6723-46ef-9043-3ced8be56e62@redhat.com>
In-Reply-To: <bd8338cf-6723-46ef-9043-3ced8be56e62@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 9 Sep 2025 22:54:20 +0800
X-Gm-Features: AS18NWC1_9y38Nsi39iOZh1hJsvE5_7RXH2EllayI3pifDOFrHDVGEcDnTcEUrc
Message-ID: <CAMgjq7BPk1PJn0JGo+ERnisSimG0FSuiQZHDY3bf2gBgE5rU1g@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] mm, swap: check page poison flag after locking it
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CE685A0016
X-Stat-Signature: ub17j8yjoqubzy53iq7az53m86ywf659
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757429698-733031
X-HE-Meta: U2FsdGVkX18Jbb61qTJ7P8oxpoLbMDru7SXMhNVQgPyWXiERT8oCgT2HJ58YdLv53Srit4jkJ3hV47usJB3dO4vooSifh64e9odFVnJUxP8zOPCteSsBRq4uRV0XesyvgRfQvYrfoypdboJN40p9lNldV8M6jG7E9cweR3d04XNl/fDKbBx4aAzkFs7d0y6qBiCuxk4i2uWBbHIvf9lJB+XwVRGYlsxoCVPOvwRpYyQwKVbcm0iqM8jDZf+aJ0pBqqhIFRi1SnxuDfCtRJxFwMiUSLWG0I89Hj+jFYEZ99CPNKwThvYnkvhBAttaRPQlom8WhWiXnExKknTgzOPH9meNa2547l9dbqTQtdisvBBDW3lw8ePTu+BvuxQ9XF2NZCNAIKfe0WVn54nMVyInWkbVw18bKaxgFWZMhwt8E0ao99US9Jv0Jvwfi55HJRMoaFYXpqr647MoaIdYUg3XTjcmH4Zse/Wb5JeKPQCmGkXx+aY4lHXoj0lW1GS2wQ4HGmaJdcrFk+qFeWEG59e7ZiWIlHAsJpjpsmc4w+h1So3ynWm45eer0oEzibMHJ/pE6YsrVUcbe+715erRwklgiQu4RZyqHQOqIe16S2fN+iVlAJv3EmeaivamFhw2xFcbbI6vzvYfenjY3l0/EhadyNBZoTodn6t7NXGiXvuEW3ZaubYF1mvj6dKZRZPUDLGUf6d4DVQ4DliqXlqdmyWxnYwD0Dcjmw/n+88oGqfrt2jzH2/A2MlyQQZ/PHxtqLK0I5VRperATFKGzQT8/4M8MUzBqkA6wttl5vORM8mdzattTs8umw0nDK7D4598cKXVfCTdPmVUnOCUUIRzAKe4TtFF1Ji05KF2/rteNdxTh47OgyqlqrhF5EO7y53E1xwOz2VA6iBVOT+j1qnvNDNnGPnhEOa220SHD0SPs+o/zv6BV7QujcWPC5K5/r8DqP3n3IxNMRJI9qLlrDprFfe
 xtHG5vNv
 b6qT85ef6DWrKG5SpfWmZEEm2GjWiZbCRsSIpb4bvWPvITJb09E+ojmCi07H3rXHKzjyMxtLVBi+KPpmaCsvW8iKYsCm5wo3sIhlkGMsC0CJHV0bIyGiJwGSV5RAsy6CjBtSxWvHshdZYBXbq0U2dkCLC5F2WQxZIV9Uy0u4j7h1ctfzW6HHuFity//nzzMRA+KvIPNwP0s/7j/1oO2YHqwrBYBhdWyAG4y/yVTTnOwrC3WUqG3NBMdNp22Dy77nqStjCQRlxy8xX+eBMgjnKMHHR0yqw9XWQbd2bB7vf2xNpC/FvoO0VmKFcVWbOMtzSg2vzGizBdWApKyHwhLwKCwPjyW++ezGO5c1C1Ij09RLmaK0lK+sHY9T8mx5vfbuAY47QBnx9KTcgb0KsU7Rhp4nxnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 8:40=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.09.25 21:13, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of checking the poison flag only in the fast swap cache lookup
> > path, always check the poison flags after locking a swap cache folio.
> >
> > There are two reasons to do so.
> >
> > The folio is unstable and could be removed from the swap cache anytime,
> > so it's totally possible that the folio is no longer the backing folio
> > of a swap entry, and could be an irrelevant poisoned folio. We might
> > mistakenly kill a faulting process.
> >
> > And it's totally possible or even common for the slow swap in path
> > (swapin_readahead) to bring in a cached folio. The cache folio could be
> > poisoned, too. Only checking the poison flag in the fast path will miss
> > such folios.
> >
> > The race window is tiny, so it's very unlikely to happen, though.
> > While at it, also add a unlikely prefix.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/memory.c | 22 +++++++++++-----------
> >   1 file changed, 11 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 10ef528a5f44..94a5928e8ace 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >               goto out;
> >
> >       folio =3D swap_cache_get_folio(entry);
> > -     if (folio) {
> > +     if (folio)
> >               swap_update_readahead(folio, vma, vmf->address);
> > -             page =3D folio_file_page(folio, swp_offset(entry));
> > -     }
> >       swapcache =3D folio;
> >
> >       if (!folio) {
> > @@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >               ret =3D VM_FAULT_MAJOR;
> >               count_vm_event(PGMAJFAULT);
> >               count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> > -             page =3D folio_file_page(folio, swp_offset(entry));
> > -     } else if (PageHWPoison(page)) {
> > -             /*
> > -              * hwpoisoned dirty swapcache pages are kept for killing
> > -              * owner processes (which may be unknown at hwpoison time=
)
> > -              */
> > -             ret =3D VM_FAULT_HWPOISON;
> > -             goto out_release;
> >       }
> >
> >       ret |=3D folio_lock_or_retry(folio, vmf);
> >       if (ret & VM_FAULT_RETRY)
> >               goto out_release;
> >
> > +     page =3D folio_file_page(folio, swp_offset(entry));
> >       if (swapcache) {
> >               /*
> >                * Make sure folio_free_swap() or swapoff did not release=
 the
> > @@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                            page_swap_entry(page).val !=3D entry.val))
> >                       goto out_page;
> >
> > +             if (unlikely(PageHWPoison(page))) {
> > +                     /*
> > +                      * hwpoisoned dirty swapcache pages are kept for =
killing
> > +                      * owner processes (which may be unknown at hwpoi=
son time)
> > +                      */
> > +                     ret =3D VM_FAULT_HWPOISON;
> > +                     goto out_page;
> > +             }
> > +
> >               /*
> >                * KSM sometimes has to copy on read faults, for example,=
 if
> >                * folio->index of non-ksm folios would be nonlinear insi=
de the
>
> LGTM, but I was wondering whether we just want to check that even when

Thanks for checking the patch.

> we just allocated a fresh folio for simplicity. The check is cheap ...
>

Maybe not for now? This patch expects folio_test_swapcache to filter
out potentially irrelevant folios, so moving the check before that is
in theory not correct.. And folio_test_swapcache check won't work for
the fresh allocated folio here...

I'm planning to remove the whole `if (swapcache)` check in phase 2, as
all swapin will go through swap cache. By that time all checks will
always be applied. The simplification will be done in a cleaner way.

> --
> Cheers
>
> David / dhildenb
>
>

