Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15378CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1BA6B0088; Thu, 18 Jun 2026 21:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91DE6B008C; Thu, 18 Jun 2026 21:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF356B00C8; Thu, 18 Jun 2026 21:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 869B46B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:57:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F02B61A0303
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:57:42 +0000 (UTC)
X-FDA: 84895000764.14.9AFDC84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08839140006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:57:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q7AktUgl;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781834261;
	b=EAW3lUW/17uiNAK8jygjdGzDFePW3sAq8T0wDLxhmb3RR5psmhT2R2Bp588awd5/gIRPaT
	iUD06XExrs1CdoHJ6Of0rCeeepYoQGfoBPgn1a7mSFaLBwVWqpqQtuaK8gLPiuAS0KTmqS
	2zv6MfeHmoitBn4XjT1LpdaW0CossvM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q7AktUgl;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781834261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO9WQ1IRvu6nku+JII2T8ZEzgXSBhXduD9kJGRWoJTA=;
	b=ZRlftuhI/NSAkdaIxODp+s6nRUiMFY9Mm/XRUsc6uwt/dJq+VPVrIBTp3tSu8UjyTVZRzs
	BzPSMzXtrePlP6DrbN7rSKseSd3XzDvefV6l3Wa6dfvle7W4NelOyuSqejvndIxmp9pZ6i
	GJj0OuDxvtOZ1vRRnsfookGIAdqGL7s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3635C44598
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D0F1F0155B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781834260;
	bh=wO9WQ1IRvu6nku+JII2T8ZEzgXSBhXduD9kJGRWoJTA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q7AktUglYuD7fd/Vrfx5AXKSV3CTyIrFaBZRkNYvsudw5r5cJBKXciAsytlwGbYlB
	 1EZU4EC+bppMtm+ZRNAJhPyFRErEzsNOBHjLTx2bX2aCySiMHL0dz5eFvn6bN9hI3l
	 K64ofvoZaJOU3r9oov5VXAt2VEgiFXPoDqX8MtQggUhcsXlT+h0YXUcXxDFh0noee8
	 9qBnaLvQ4/OW30pYAaWYCxUagkSr+mPZZwHA7u6fXfC/lDIsOdBSnwRZkGHMDfOJXW
	 o7QzfYN9dovyAxWC3hKfXrpb6EZM+WQ7Kc5YAb+ZFTQcvcASwYNV38k730tese5zod
	 6MJ3FVVI3jZgg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9203654905eso61882485a.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:57:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9gq56C8YzWbLD+z/uqF4MWFak0H3s3UMnccE7rPir7fRxZbr9szPmgPhp2+OHGc8UMd6MO9Um2hw==@kvack.org
X-Gm-Message-State: AOJu0Yx363JQtXz6iy052c8g/f5Qyi4YyExG+h2S+pSpiJUU+EtwZtrJ
	nfr1gEKpCI/RAj9lY5lFpQEDj5n2wwiKWCgwtMBBUaJ+M7O6+jeUsGrn6L1GwcVAZJiJG5h2DaD
	WLdtojU6zjeGDLJ5HPYN5bvgeOmjoxMo=
X-Received: by 2002:a05:620a:298c:b0:915:afa5:754 with SMTP id
 af79cd13be357-9208e982356mr268858385a.2.1781834259290; Thu, 18 Jun 2026
 18:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-4-baohua@kernel.org>
 <CAMgjq7D0roMW108dP60PaCTnYfSDCA7GyGDATn-nLD8kiNViuQ@mail.gmail.com>
 <CAGsJ_4yZVGcpKzvRE+tvdqLrP-rQP9c7iHrGLCttyUkSQAndPA@mail.gmail.com> <CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com>
In-Reply-To: <CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 19 Jun 2026 09:57:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zzmDXOAmr7hfigV1MM8B5esKgQ3AJ_OUWSmHR3F5QvUw@mail.gmail.com>
X-Gm-Features: AVVi8CdvIqaTDMdqD7Ag8ZymugoXLKApZKKRfMLEmDwn-TtCT5FgQd4gj3UxUuI
Message-ID: <CAGsJ_4zzmDXOAmr7hfigV1MM8B5esKgQ3AJ_OUWSmHR3F5QvUw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9uhtxpka6xnm4xysahmb9j51io9mz4z9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08839140006
X-Rspam-User: 
X-HE-Tag: 1781834260-606546
X-HE-Meta: U2FsdGVkX18hQZo3l5n/HaqORi+Y+JH6XYWiRjgaWK10DJe1MkG8QyAQHFk94kLsBOOVaOt1qYcndxhtB4dlKKPBzi2TYjLWbFSEfq4FHuYzhC9Yg0qxYzW64McI1WYDDKdtDWMxALq4Yq/M2FHU6QMPeglpcnJBz0MCBZohzgDDofaA2ttzd2j6gY4aExxQOI/scRpfpaA1r+/ghGv1uASZ2G/JpeawpApae8pGvkZU2IY3Kg7uc+6GfW2BMg7b1Ji5gJzh5yuVB9KTSA9bGczL19ASXfKXnfdaY8uXIZY6GHoD4qvO1GEY7keV+idHflC6bYJ3uYlpP/Lz5aPZitSa23B786xijQWxxr9KzSCIPWPBnWM3UNJkQ0fk0vq8FBNBiJf5PfuMcMDIPt3tKU/xylmeo/SfPAxOtiHxy4HalxwoBK/92Zuw+Wr/1H6r/sT4XTtiRgZ+bSU5DnGA5GkUfOc+oVgUlPbMIw+J/NKzQRnYk3LPjaQkekwyARBqM9n40YGrFPTMqK3w2/fZeESWlgqGZsq+5qZd6jo8I1QSrW7sR3Gmpmxj/JAwQiz+c3epnylC7yfYTFY7ZND6bhUa23yE6AyY1Xp1TU4L2lmNW+AZVJooRJgeXXP4zdLrDdUNCFsyAmsJwSFBiqB0n5QieQkFgmtaoxEd5DkHMR30q6Ix8/xbxdV+Dxsb6Xicg7Cxg+CO6INopHUKmYt0Uz15DaPWXq3DW80P7AaN4BW+aye6NS6zTIqte2E0QqXWn6pTlJh9peLxNIyx3xxDE5GVABMtZiV31h1ls7+MapPqETnZQb/VPBxtL/yJ/Om2MA4pp9Vt2PSocWnEAkzbJRnsfvIjE3rJ1AOmCztQJymayjnaZS9G+TyksgE0OZ+MHmouCtvvZszVTC08oa11GVv/rM5dBFSiGq2vkZnoyMTuPt6ppm6t/3H87SGNMxd0ptkJ1PSBNpt9L+esoWg
 HFkjJm6O
 7lVl0oTHE5hFP5aki0+IFGRbeEeQgSZYvX564rCkNWzAEM2wDzVfstWE7HpcIa+XkcRH4qlAoQ56B1KJ/Nha5F32NXyuHoujN5hM7XE8LXNQIze/TRbM23KocUJaKEuc0N0taAqfSwW4TIu+WHK0U9cx6LX6O04ENEznFG0yCaIMur3PCYuNBgAcUBgumxOe4ZmtWRgGzsMMAUG27V18AG1SNwH4zXOoh/6ZhR3FKwkEohg2zE3SWc3nYiJgYXISDP2e1m7bhlgNay+fa+8mI8FNnHyS/5kglUb8nBaaYps7ztiMEdu9LJ9B+Ah7ydoOJPtgKixc8yzYZIzpvUVFUKwmGnDUM69kOYuh08mBifFcygzifpNe46AemdArTXaNUjRj9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 3:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Jun 17, 2026 at 5:55=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Wed, Jun 17, 2026 at 1:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Thu, Jun 11, 2026 at 6:52=E2=80=AFPM Barry Song (Xiaomi) <baohua@k=
ernel.org> wrote:
> > > >
> > > > We are doing a lot of redundant lru_add_drain() calls in
> > > > do_swap_page(), especially for synchronous I/O devices. For
> > > > example, the test program below currently ends up draining
> > > > lru_cache 100% of the time:
> > > >
> > > > int main(int argc, char *argv[])
> > > > {
> > > >         int i;
> > > >  #define SIZE 100*1024*1024
> > > >         while(1) {
> > > >                 volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_=
WRITE,
> > > >                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > >
> > > >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> > > >                         p[i] =3D  i%64;
> > > >                 madvise((void *)p, SIZE, MADV_PAGEOUT);
> > > >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> > > >                         p[i] =3D  i%64;
> > > >                 munmap(p, SIZE);
> > > >         }
> > > >         return 0;
> > > > }
> > > >
> > > > Folio reuse now relies primarily on the exclusive hint, making
> > > > lru_cache draining to drop the refcount in lru_cache largely
> > > > irrelevant.
> > > >
> > > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > > ---
> > > >  mm/memory.c | 10 ----------
> > > >  1 file changed, 10 deletions(-)
> > > >
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index ce8ef27e7a54..b5a78670bcc8 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf=
)
> > > >         } else if (folio !=3D swapcache)
> > > >                 page =3D folio_page(folio, 0);
> > > >
> > > > -       /*
> > > > -        * If we want to map a page that's in the swapcache writabl=
e, we
> > > > -        * have to detect via the refcount if we're really the excl=
usive
> > > > -        * owner. Try removing the extra reference from the local L=
RU
> > > > -        * caches if required.
> > > > -        */
> > > > -       if ((vmf->flags & FAULT_FLAG_WRITE) &&
> > > > -           !folio_test_ksm(folio) && !folio_test_lru(folio))
> > > > -               lru_add_drain();
> > > > -
> > > >         folio_throttle_swaprate(folio, GFP_KERNEL);
> > > >
> > > >         /*
> > > > --
> > > > 2.39.3 (Apple Git-146)
> > > >
> > > >
> > >
> > > There is a ref check in should_try_to_free_swap though, perhaps we
> > > should also improve that part too or we may have more more folios
> > > stuck in swap cache after this change?
> >
> > Good catch. We could assume that a !LRU folio has an extra reference he=
ld
> > by lru_cache. Does the below make sense to you?
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ff338c2abe92..237220ae1572 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5094,8 +5094,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >          * Remove the swap entry and conditionally try to free up the s=
wapcache.
> >          * Do it after mapping, so raced page faults will likely see th=
e folio
> >          * in swap cache and wait on the folio lock.
> > +        * Assume that lru_cache contributes an extra reference for non=
-LRU
> > +        * folios.
> >          */
> > -       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flag=
s))
> > +       if (should_try_to_free_swap(si, folio, vma, nr_pages +
> > +           !folio_test_lru(folio), vmf->flags))
> >                 folio_free_swap(folio);
> >
> >         folio_unlock(folio);
>
> Right, this seems better. I've been thinking if we can just remove
> that ref check in should_try_to_free_swap and always return true to
> reclaim the cache for write faults. However, that seems like a bad
> idea after all since shared clean swapin folios on non-sync devices
> might benefit significantly from being cached, and such cases are
> unlikely to be very rare.

I don=E2=80=99t quite understand what you mean. Even if we remove the
refcheck folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_pages(folio))
from should_try_to_free_swap(), folio_maybe_swapped() would still
prevent swapcache from being deleted for shared folios. The only
effect is that we end up doing more work:

        rcu_read_lock();
        do {
                if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
                        ret =3D true;
                        break;
                }
        } while (++ci_off < ci_end);
        rcu_read_unlock();

and should_try_to_free_swap() currently checks
fault_flags & FAULT_FLAG_WRITE, so clean folios are not
touched for their swapcache.

The only thing I feel might not be perfect is sync I/O, which I
think should be:

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..3c231dafefcb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4517,14 +4517,6 @@ static inline bool
should_try_to_free_swap(struct swap_info_struct *si,
 {
        if (!folio_test_swapcache(folio))
                return false;
-       /*
-        * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Sw=
ap
-        * cache can help save some IO or memory overhead, but these device=
s
-        * are fast, and meanwhile, swap cache pinning the slot deferring t=
he
-        * release of metadata or fragmentation is a more critical issue.
-        */
-       if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
-               return true;
        if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
            folio_test_mlocked(folio))
                return true;
@@ -4533,8 +4525,12 @@ static inline bool
should_try_to_free_swap(struct swap_info_struct *si,
         * have to detect via the refcount if we're really the exclusive
         * user. Try freeing the swapcache to get rid of the swapcache
         * reference only in case it's likely that we'll be the exclusive u=
ser.
+        * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices, ev=
en
+        * when swapin is for read, to release memory used for compressed d=
ata,
+        * etc.
         */
-       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &=
&
+       return ((fault_flags & FAULT_FLAG_WRITE) || data_race(si->flags &
+               SWP_SYNCHRONOUS_IO)) && !folio_test_ksm(folio) &&
                folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_pages(=
folio));
 }

Not sure if it is worth it. I feel it would only save some
overhead in folio_maybe_swapped() when we have many shared
folios.

>
> Just one thing: I think maybe we can have a more common helper to be
> shared by `wp_can_reuse_anon_folio` and `should_try_to_free_swap`.
> Since the cache reclaim in `should_try_to_free_swap` is meant to help
> `wp_can_reuse_anon_folio` (IIUC), keeping them more consistent seems
> easier to maintain and understand. Trivial though.
>
> It's fine this way too, it's technically correct and this is only a
> heuristic check which doesn't effect correctness.

thanks! I would stick with this approach for now, as
wp_can_reuse_anon_folio() and do_swap_page() seem to differ
significantly in how they handle SYNC I/O, folio locking, etc.

Best Regards
Barry

