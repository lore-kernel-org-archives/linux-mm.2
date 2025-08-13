Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEEFC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 09:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9AC90004F; Wed, 13 Aug 2025 05:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481B6900044; Wed, 13 Aug 2025 05:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEDF90004F; Wed, 13 Aug 2025 05:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6F1900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:03:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E137313781E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:03:16 +0000 (UTC)
X-FDA: 83771145192.20.419CEF4
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07A5540011
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:03:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XBJN9Qho;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755075795; a=rsa-sha256;
	cv=none;
	b=loQUlABbkxSlq/kuynCW3A8pH73Z7fufuJ7q7kMBoavKoHkar2iBgtQCjziyrEiKdGqcJp
	aiPhMnnAPwNSVKPXcK7MBQQj+/OpQ/i13tJieUSbbRULmhTX7aUW982zY5vkIWGlDfT/V0
	gbtC/ywzveuRk2iNLiVkzwJFjcb4SHI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XBJN9Qho;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755075795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voNOIsNIDIOSY89DvHxjFqypSpnZL2H3uOxQi9alac4=;
	b=fZM+lVz1BNkVOYUz4Y6BnqMH3Sj3Agj69G6E/VxHCVA4Xq2Rdl4WQMzL9/HI/snlfhejD7
	GHWr2Oaj4qGUNKO0khH1oDVxH00e8kDMCntWZQZw8q2YJ0A06FaWZMOz966gloUEpvS3Iv
	qCqs7p6co9GwwQTG4gUhIYQT1DeqrzI=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-53945ba7f2aso4621036e0c.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755075794; x=1755680594; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=voNOIsNIDIOSY89DvHxjFqypSpnZL2H3uOxQi9alac4=;
        b=XBJN9Qho6pApL2mjXoBFam4PlBWWXDxYhDPTdPJNbsqIEb3kq7wkQ4zA+I3yPiTyec
         eQpwOBwvRsC52Q+7/5Igm1SA2OuB0lOZ8//rNWx6+wMIa+xXBt+K9ZdJ2BDG++GP+S9b
         5oMMS3o61od/xoMK27f/eh7hzFMJFeJHeI0GIkn395v7LGFKYu12fCYkNwJ+4LFY4Qgf
         S51XAQnfJLpxA9QjIiI2uHDeDnzckpgHIQ1ByF6w8CdgoPsZ2jkeRvVACf1pgsJ3TjtM
         rFUlJuY+eIeTPZTwturbAl9zGh/AJ5ieRM47mRcWOOppYLbkTPJSYXTiv0/xp2/m0B59
         dt8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755075794; x=1755680594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=voNOIsNIDIOSY89DvHxjFqypSpnZL2H3uOxQi9alac4=;
        b=aPqePueeVP3elsjRioGd4QDwvT2ER2eIrnCNBwKqYLFr/mGy1XS9bRXzrMQT6u5/N3
         z3zSHZTWK0+aXG6XCOQSJpcr6FFv4T1J7Kwa78crbhjcLXqMHPoBOWOCCY2Dd6+dVDrC
         /ketiRgY2SF9QXSLRqEkedXuoV+h2zM0okoaS4tAFzqMg4vIxFFM3iGl7OwFzwcrn7HM
         js1QumNrE5EaZ1PASrpOkiHMb8sGQEsoPe4c0RTRDP+vFPlO5b9tBOKFBRo6PWng1EbM
         1kHzzFsHUVuufbHL9xiH5zrnP9cYyzztSPW8FPWw0Umt1ZiqBUnX4MLxi1gKCM7FY0Tj
         xvKA==
X-Forwarded-Encrypted: i=1; AJvYcCW2bHoHY9YiU8rShfqFOaPYxc22AFQDlbXqL1AeHnRWCpflMHORPmPyGv/J1yenTbgpcc2k7Wl0/Q==@kvack.org
X-Gm-Message-State: AOJu0YzltWpfw99Ci3By9UFuKPPEPAkxmwZ76NDeaVtt4vmKsKRoQyjA
	ncJsr4gXzGKlcSDcR8+gwW2IXj5VU1dEl9eoHt1Ohh5+Z6Bb864lQxBzzFmdOEN2q+iL2J85TGH
	KumU0Pk3iziZHaPZiFZDNYrDkJkJR3YU=
X-Gm-Gg: ASbGncu4GX7IAQEwzwtPG3JsvsK/B8AbFvmevVtoERmX7Fr28Nctx38xhP6w6uQLDOK
	vhzUvvsdj5avN6xfLRhNMeTsPOgYx7oHKFig4FBNckBgCASZqnA66Ma8CkodaLs5S4eFTgVgX2Q
	k0n4vON8nZerw5EwgvtXN7Gi+cYopYXWorIhmLcvqcNTPeXxws5/A8H70eXXGpLno8noPMB2DJU
	fL+e0CJaGIsE/KuGA==
X-Google-Smtp-Source: AGHT+IGuh9iHJ1JWc3gYcYGVmBmp0xY+JZbyoVk+K1ITPktWKiItf2ByWP4lQ9Mmtl//A68HDXzuauOSj81kR2pdG5o=
X-Received: by 2002:a05:6122:2090:b0:539:4097:794a with SMTP id
 71dfb90a1353d-53b0b66e1dfmr619879e0c.12.1755075793795; Wed, 13 Aug 2025
 02:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
 <aJtTPkenKeFuFFNQ@x1.local> <CA+EESO763JtY3jjmgGGbJjSQcnJJFNpDs2iPaUwjP44VpyyzdQ@mail.gmail.com>
In-Reply-To: <CA+EESO763JtY3jjmgGGbJjSQcnJJFNpDs2iPaUwjP44VpyyzdQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 13 Aug 2025 17:03:02 +0800
X-Gm-Features: Ac12FXxub7pbHdwNO3uqCxu946h-k9RRK50QHzhG6uYyQAeU83e_ljmwtaOwEXY
Message-ID: <CAGsJ_4y98H-8aK9r_5YrSPV=SCU=-rZf7YPMz32K0C8oFnUCNA@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 75w55h1tkmat8533gzxpsexokej54xo6
X-Rspam-User: 
X-Rspamd-Queue-Id: 07A5540011
X-Rspamd-Server: rspam02
X-HE-Tag: 1755075794-645366
X-HE-Meta: U2FsdGVkX1+PWaguDLW8ZnUGA2Q2WS8IwTafwkhlvsM25u/X3oyIkXOCA63viC0GwEM27iZ0KC9DACwhAh6L2QW2rJx4F7yO8kPQeS6YmB0iEA0jUgoIUxPGxPfJVNhuwiDbYb3p8iZCHoxWQbihIw6EAVvHXo40n+gjI3Hk0n7ZHYdoUXEw4F8X1tXTvE5PLYKfGpkd45OUph5yPavgqxcw/9CxcX/XnP+KVAEh6VnsegFBNGsaSdfplvZ4Hlon1gYVOyBVeQeeV+LNHU7xAqK/72mcmHnPX40uETvOdrKJeAgrM/+sQ+gFo9ZFJNoZJ8VXt3kaecav5IMS41LayEITuJn7yGYYvOy2adDSUJndhzcSMrCOiArzeJGHEpVj6SOwHq/JYyED5KLREXaXSjFJSSz/W1NxeeBuLFdSeOj4Qz/ZbEfwMspOmEQe5rlXYpgeWPOVPZv9Fwin9/Va2wTdHKWmH/3UCF34k0TLLaMIHTAkxlhz/QqlCeWbQXjjheiievmN6UAbitdjsoWba81SY7N59K2w9d0LDKsupIf1PPw6bcHXB8rOPVBVbx5Q5ulEq70AS0Nwmc7Ek+UNVqUVYYui6DLAhCtZMne+3jpPckcIzrxZNKtAh9Ag+QfrDVS31JZLq5JI7w76/b2T0X4jONhmfGXrfjofbbH7c9MyI+kTFl+M0PXAmOH9DuDLQVFIYtIXvk+OE6mnYh0f3Ruptag7n1QZwkbg3v/mURgAISiqLNij2Pa/faZtnC9QpJdWAyCTpcaGvBtwYMJURnpykvpdZsLGDDuNjoVO9m7/azXwNXZE44EhBEisIL25cxoGrOzdIfNPKX2GZcf9SScX6Br5SV5KlxH5Rq0Jx5w0d2YdSWKy3OD1/NbihV+lGvkvAeXfZxeVeTnnVJPgY14N9Yv6vhN2UBa205Wvu/FqW0xQj8V8oVPWD3cFRw0VhdY3UXSlaqpip8doR0V
 QZsvgDOg
 lxqU6Z7uYmUVFpx9K4VciFy+iCvkn2h8pFpwKkNU4GSxHgfC7/q0qAbHxn3pXPWTnujXLCXoePj5hQvaiQOoekwVaygbZ0cV9eWkfDlcYjEsB6nUhLol0RFhOsFWiZLxOQoMaey1maJljZSsqrczLfAhusxUqUCEWHvjJzgeByn2Bq/PvlRNpf4UR7G80BdNaKmLpARmkE//6FOkyoqVmCFqwfhoWwhnf4BrMXAdJXi+do2KP1bOP5IHxyyZmvtyY03JbfYq6vXhzpWuKXZvLDQwqJGCepUlGzZOvY1UoHo3kd/vs16yyDGUcb+IuWIBsV1VLFgT7ucdo07SRmgpP8UCLazE5hPXxXlF10FZD1Dcrh08qf4C7gX3p34cVidOz7nKd7g85zihVDMkTXF0Dro6zMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:44=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> On Tue, Aug 12, 2025 at 7:44=E2=80=AFAM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Mon, Aug 11, 2025 at 11:55:36AM +0800, Barry Song wrote:
> > > Hi Lokesh,
[...]
> > > >
> > > >  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++----------=
----
> > > >  1 file changed, 127 insertions(+), 51 deletions(-)
> > > >
> > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > index cbed91b09640..39d81d2972db 100644
> > > > --- a/mm/userfaultfd.c
> > > > +++ b/mm/userfaultfd.c
> > > > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_=
t *dst_pte, pte_t *src_pte,
> > > >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > > >  }
> > > >
> > > > -static int move_present_pte(struct mm_struct *mm,
> > > > -                           struct vm_area_struct *dst_vma,
> > > > -                           struct vm_area_struct *src_vma,
> > > > -                           unsigned long dst_addr, unsigned long s=
rc_addr,
> > > > -                           pte_t *dst_pte, pte_t *src_pte,
> > > > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > > > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > -                           spinlock_t *dst_ptl, spinlock_t *src_pt=
l,
> > > > -                           struct folio *src_folio)
> > > > +/*
> > > > + * Checks if the two ptes and the corresponding folio are eligible=
 for batched
> > > > + * move. If so, then returns pointer to the locked folio. Otherwis=
e, returns NULL.
> > > > + *
> > > > + * NOTE: folio's reference is not required as the whole operation =
is within
> > > > + * PTL's critical section.
> > > > + */
> > > > +static struct folio *check_ptes_for_batched_move(struct vm_area_st=
ruct *src_vma,
> > > > +                                                unsigned long src_=
addr,
> > > > +                                                pte_t *src_pte, pt=
e_t *dst_pte,
> > > > +                                                struct anon_vma *s=
rc_anon_vma)
> > > > +{
> > > > +       pte_t orig_dst_pte, orig_src_pte;
> > > > +       struct folio *folio;
> > > > +
> > > > +       orig_dst_pte =3D ptep_get(dst_pte);
> > > > +       if (!pte_none(orig_dst_pte))
> > > > +               return NULL;
> > > > +
> > > > +       orig_src_pte =3D ptep_get(src_pte);
> > > > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_=
src_pte)))
> > > > +               return NULL;
> > > > +
> > > > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > > > +       if (!folio || !folio_trylock(folio))
> > > > +               return NULL;
> > > > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(fo=
lio) ||
> > > > +           folio_anon_vma(folio) !=3D src_anon_vma) {
> > > > +               folio_unlock(folio);
> > > > +               return NULL;
> > > > +       }
> > > > +       return folio;
> > > > +}
> > > > +
> > >
> > > I=E2=80=99m still quite confused by the code. Before move_present_pte=
s(), we=E2=80=99ve
> > > already performed all the checks=E2=80=94pte_same(), vm_normal_folio(=
),
> > > folio_trylock(), folio_test_large(), folio_get_anon_vma(),
> > > and anon_vma_lock_write()=E2=80=94at least for the first PTE. Now we=
=E2=80=99re
> > > duplicating them again for all PTEs. Does this mean we=E2=80=99re doi=
ng those
> > > operations for the first PTE twice? It feels like the old non-batch c=
heck
> > > code should be removed?
> >
> > This function should only start to work on the 2nd (or more) continuous
> > ptes to move within the same pgtable lock held.  We'll still need the
> > original path because that was sleepable, this one isn't, and it's only
> > best-effort fast path only. E.g. if trylock() fails above, it would
> > fallback to the slow path.
> >
> Thanks Peter. I was about to give exactly the same reasoning :)

Apologies, I overlooked this part:
                src_addr +=3D PAGE_SIZE;
                if (src_addr =3D=3D addr_end)
                        break;
                dst_addr +=3D PAGE_SIZE;
                dst_pte++;
                src_pte++;
                folio_unlock(src_folio);
                src_folio =3D check_ptes_for_batched_move(src_vma,
src_addr, src_pte,
                                                        dst_pte, src_anon_v=
ma);

I still find this a little tricky to follow =E2=80=94 couldn=E2=80=99t we j=
ust handle it
like the other batched cases:

static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
                        struct page_vma_mapped_walk *pvmw,
                        enum ttu_flags flags, pte_t pte)

We pass the first PTE and use a function to determine how many PTEs we
can batch together. That way, we don=E2=80=99t need a special path for the =
first
PTE.

I guess the challenge is that the first PTE needs to handle
split_folio(), folio_trylock() with -EAGAIN, and
anon_vma_trylock_write(), while the other PTEs don=E2=80=99t?

If so, could we add a clear comment explaining that move_present_ptes()
moves PTEs that share the same anon_vma as the first PTE, are not large
folios, and can successfully take folio_trylock()?
If this condition isn=E2=80=99t met, the batch stops.

Thanks
Barry

