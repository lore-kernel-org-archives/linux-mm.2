Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEC2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 22:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA316B0107; Tue, 26 Aug 2025 18:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0066B0108; Tue, 26 Aug 2025 18:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5846B0109; Tue, 26 Aug 2025 18:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF63A6B0107
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:23:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EECD5888E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:23:44 +0000 (UTC)
X-FDA: 83820336768.15.3CDDB8C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67A651C0004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:23:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aE7DHrfc;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756247022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdzAj4hdgXbHM9u8eX6/Ze1u+O9VPPOiYd1/e8bzusU=;
	b=rokQ2XqjCgcru91LqecdeqOEirrdSavDaTbDl2sP2LOnRvKpWjRugGvzXlXismU2/hqj9c
	VbMK/MW8ilbmucM0aUkj1SJ7CDgSHl7r/wXm/fED8luFLmjh1gSphRUt+2Q1dBlUqV0cRq
	vdUXMVOuPMSW4g+yDW5kcC6HJg6RRCQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aE7DHrfc;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756247022; a=rsa-sha256;
	cv=none;
	b=2cXHafBOoEaX60rPkfCzRlQkGgPLh4dbCiReHvf8X9xS9MIUY43UrYvvkb8ZKiRAIu2ZiG
	DCynFII1kSElATwsRYnUPq6YFRR/3IwipGG91D93zWJSFbL1hzoLass9Ho13G3k6wn5pAp
	XPMBLjYX9O1g4y8cYgHt9y8OfnjI4Wc=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61c869b4623so2101a12.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756247021; x=1756851821; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdzAj4hdgXbHM9u8eX6/Ze1u+O9VPPOiYd1/e8bzusU=;
        b=aE7DHrfcWmugXm9mhXT5X9eJBxLVl2CJzB4vXsK6svLhogBTLFP1Zamk8R8GKmjvq8
         jDxVQ4JYXmDuqwyhi8gUQ0wmquqFrvY1DSNNPDvsxCYrzgJrNntNTRvaLrkxEZEVmpwj
         g1R9aHq0OmQ1/ur+eLlm/RaudU3kZ3aBgcyitPeUMTKKS/if5edd0+ynPL7lF89iSGC0
         ptbdZdvaD1Eoc286/mf4fUmBqIRkC8h3wfnxV3vGyByBIsCSzxNMojLDvBXCwJXzFak1
         wxdQyfyZi0Z9j/2TjHnoEx9Mb9+K/iu+UrsoJQZAY9++eQpWHRtEh8Xw33ZKI8Z6zU3G
         NdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756247021; x=1756851821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HdzAj4hdgXbHM9u8eX6/Ze1u+O9VPPOiYd1/e8bzusU=;
        b=NMopkGlkqWpYu7cGD78ROPn7XSPEx9PIUg7Jpt3gRbL3PKQSA2rUSREabx7N+tsUqJ
         HysYoer4pfGplYN5ZkypKZ4D10AbqEk9xe7p2J7BEZfxVb2nZ/Ox2d0WcwhEcdM8sLQS
         HPvYlkzjuVuBoeRN9+Kho2ONAR1CmBnO1Po8rq2ajSK5M+m8IBmimFXW/Nx80v/3YnGM
         bclAkODw4tribG9PQlCx7wcA95qDbTUpk9HhZe8+EvZl1qA8LzJ+lvWoOphhjFSZSJAe
         TMq90zCRTjLwsCZ7ifP6s2pXYxFOJBmmIRDsd4gjjyoVodtU7rQr+/1DUKu4U6azLUWC
         Ewiw==
X-Forwarded-Encrypted: i=1; AJvYcCVaAKcqcLMB0qPFSIzSQZZhFHCT+AtCe+E9QdiHLnhMZy5M2YUl5lXBBvpqm3Jau+r+P6rMz7VD1A==@kvack.org
X-Gm-Message-State: AOJu0Yx68NXowh8LrgAwJCJ11L3Wrdq3JW66WcO1pt5iWtaAyUJ7ojOo
	0NAMI0X7bQhMTPxt0+/PO8jBanbphTNR4iYPHAtJG6EdTj8HssxrNUdhD0z2CDoRx06Ge80E+pU
	TA2MKpFnOPG+FAhwo4INvtmBtKS252dTwulQ5kz54
X-Gm-Gg: ASbGncvPciJ6j4RRi252QtmhucGOIguyDZ+TflrKm8/K8E32h4eX/b1r8B46BlcupB6
	1aEtuMNat1HKq5Xz1NIdR6ZgKa9c6EBPSLm3kKVMrWjxA1j0YUgHw9DBkrNYrx9L7PNSYwy2s/N
	CMV4IdeDwd3hTi7l3HvCoyYCZISpuUO4FAKj89An7AC+sivBoj5b6AzSqPERhhLcjEOGoLXRk6o
	2txTo7OJe8xsx6ZG5ZJ86uBJ/sA6HNfJcRkDcjxfg==
X-Google-Smtp-Source: AGHT+IH5laHTN2ceQXtx48Rb1PyJw6NCArX3BwpFynb13vIQot7VtB6qXl2BVraBEpEyuBdH6PnHzmOOsPl0buTNmrg=
X-Received: by 2002:aa7:d817:0:b0:61c:ad8d:eeb3 with SMTP id
 4fb4d7f45d1cf-61cad8def77mr105462a12.5.1756247020395; Tue, 26 Aug 2025
 15:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <65dd5d54-87ab-49a8-8734-2201a0014feb@lucifer.local>
In-Reply-To: <65dd5d54-87ab-49a8-8734-2201a0014feb@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 26 Aug 2025 15:23:28 -0700
X-Gm-Features: Ac12FXxHsj5ejTjMAqm2KdWR-My4JCztbeCu5nshJDlgNWqk9Y_R3t6Y32y6-PI
Message-ID: <CA+EESO5zUO8x21u1KAG5U3Rghaxw8GFGZMhsbM3E2AyeHFYRMw@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67A651C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qmgwb7s9un87n65gp13qme47i6fs9i7z
X-HE-Tag: 1756247022-474513
X-HE-Meta: U2FsdGVkX18PpY1J/ytfSecvwcgVN6JKjT9CbCB6HdEITdOeZkOaroIF5Hspb7nMlfEG8ls9b7bE0QA7r8pb7SLfiNYIjSGmtxn8/2nYenUVLoaCnmM3LCjHBTcpqAf2nZ08XXAh0ZSW2VOYwMg8Nc70Y9/bt3EVGbcQrez8+DTBetOabZHCOflDw9qa+h1wDIaMyuaHt7haZwJrQLmndCJGgdJEwjgtUV7Cq5EzEslWDIyVJE89nUlr3f0Ook7w2Ihzxk4sP+ibXBXZGAhuEwRvtgxJn8KFlOZtO/Bnh1z/dp2p1xgxasCwFT9Mchr3qNaD0RK6IKc2asWeNlP25Ks9F7ryG0q2oPt/FSsc0663O8mWS1hqQe8VCQ4vrgsfa3Yg1GfshQhs+HFr9S1o9VMBMQBU5YFaxi4xXQ0Un1clNYKdPVXk0QSutvu5oa+r6t1TI4D3KB/MAhXSeHfzCZmj6tGlOUfV9ulbgb+HhfgkF9qFSPkARsJ0O7Yw3oz3P2ls7pkT/61xGKeuuaHe5vwmPkFID55q27oeWhD2iJlkgnssc54zDry3Ygp3/b4zS+csBWIefusokKltzry5Ow1zPjj0TzacHOImu8lehlTn2j9dPym31bLfxc14kVL1xYPSmSW3hvcvPkDyTdu3Znfro13JEIw+3pDDgetdfNoyTgu9JdhSQbOBDw65/V9eNOCMFJIFmLzVWr69nKyuUcrkqWOwbEjlqQAWU3TMqC8S9V1PtnBS1nXItBXY3nVX6JS5fteefEye67E+nTxAn4+L9a/9X8uRHlXlLGMDOyeDgpsn7A9M72KHqcm675FMhByl5L7j17BmJRESWeerqdl+I3YyNeu53ffOeRRlJLgf2DVGjG6nF8Eau/Wruwk7TOn8rxbmgy7jFkYR3/LKZDsntoIO/bplcOtnmeUlc0BFoZLNytA+tBtJw+M09baiLBvD0Vd+Av3txh4SxIZ
 EFSKweQd
 vVwjpMp42iHf7Kp3MFv5ldwHA4HM0gQeAiMOzmA94yiIFwW/ohJoN5wxX6DIJyjCu0SI7YhcmfG2sSrs7l1YZIByhzPOwEzMLEjI+NfeRiAeqoSxQ2bR51we4VfIp250SC82iPWYPKFKJ8/On0unUZPOopmXUTkOIf/6mYgvxMeZnKma6GlITjduUNW7MkK78YxiCeajQsrWMmBGvqfyf29IB57kdpmK4yesgAS1oz5m5X7l5pknvw4yhjaKgr+c9/yVDYuwhQI/VbRU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 8:52=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Aug 22, 2025 at 10:29:52AM -0700, Lokesh Gidra wrote:
> > Hi all,
> >
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
> > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > involved in rmap_walk()) are to be updated. This hurts scalability due
> > to coarse granularity of the lock. For instance, when multiple threads
> > invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct=
 pages
> > from the same src VMA, they all contend for the corresponding
> > anon_vma=E2=80=99s lock. Field traces for arm64 android devices reveal =
over
> > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > user interactions.
>
> Can we clarify whether this is simply an example, or rather the entire
> motivating reason for raising this issue?
>
When I started off I thought maybe there are other cases too, but it
looks like as of now only uffd MOVE updates folio->mapping to a
different root anon_vma.

> It's important, because it strikes me that this is a very specific use
> case, and you're now suggesting changing core locking to suit it.
>
> While this is a discussion, and I'm glad you raised it, I think it's
> important in these cases to really exhaustively examine all of the possib=
le
> consequences.
>
> OK so to clarify:
>
> - You want to traverse the rmap entirely without any rmap locks whatsoeve=
r
>   for anon, relying solely on the folio lock to serialise, because
>   otherwise rmap read locks here block other rmap write lock calls.
>
There is a misunderstanding. I'm suggesting locking *both* folio as
well as anon_vma during rmap walk. To avoid any confusion, here are
the simplifications in mm/rmap.c that I suggest:

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..81c177b0cddf 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -547,7 +547,6 @@ struct anon_vma *folio_lock_anon_vma_read(const
struct folio *folio,
        struct anon_vma *root_anon_vma;
        unsigned long anon_mapping;

-retry:
        rcu_read_lock();
        anon_mapping =3D (unsigned long)READ_ONCE(folio->mapping);
        if ((anon_mapping & FOLIO_MAPPING_FLAGS) !=3D FOLIO_MAPPING_ANON)
@@ -558,17 +557,6 @@ struct anon_vma *folio_lock_anon_vma_read(const
struct folio *folio,
        anon_vma =3D (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON=
);
        root_anon_vma =3D READ_ONCE(anon_vma->root);
        if (down_read_trylock(&root_anon_vma->rwsem)) {
-               /*
-                * folio_move_anon_rmap() might have changed the anon_vma a=
s we
-                * might not hold the folio lock here.
-                */
-               if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=3D
-                            anon_mapping)) {
-                       up_read(&root_anon_vma->rwsem);
-                       rcu_read_unlock();
-                       goto retry;
-               }
-
                /*
                 * If the folio is still mapped, then this anon_vma is stil=
l
                 * its anon_vma, and holding the mutex ensures that it will
@@ -603,18 +591,6 @@ struct anon_vma *folio_lock_anon_vma_read(const
struct folio *folio,
        rcu_read_unlock();
        anon_vma_lock_read(anon_vma);

-       /*
-        * folio_move_anon_rmap() might have changed the anon_vma as we mig=
ht
-        * not hold the folio lock here.
-        */
-       if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=3D
-                    anon_mapping)) {
-               anon_vma_unlock_read(anon_vma);
-               put_anon_vma(anon_vma);
-               anon_vma =3D NULL;
-               goto retry;
-       }
-
        if (atomic_dec_and_test(&anon_vma->refcount)) {
                /*
                 * Oops, we held the last refcount, release the lock
@@ -1006,7 +982,7 @@ int folio_referenced(struct folio *folio, int is_locke=
d,
        if (!folio_raw_mapping(folio))
                return 0;

-       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)=
)) {
+       if (!is_locked) {
                we_locked =3D folio_trylock(folio);
                if (!we_locked)
                        return 1;

> - You want to unconditionally folio lock all anon and kSM folios for at
>   least folio_referenced().
>
Actually file and KSM folios are always locked today. The anon folios
are conditionally left out. So my proposal actually standardizes this
locking, which is an overall simplification.

> In order to resolve a scalability issue specific to a uffd usecase?
>
With the requirement of locking anon_vma in write mode, uffd MOVE
currently is unusable in practice due to poor scalability. The above
change in mm/rmap.c allows us to make the following improvement to
MOVE ioctl:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45e6290e2e8b..c4fc87d73ab7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1192,7 +1192,6 @@ static int move_pages_pte(struct mm_struct *mm,
pmd_t *dst_pmd, pmd_t *src_pmd,
        pmd_t dummy_pmdval;
        pmd_t dst_pmdval;
        struct folio *src_folio =3D NULL;
-       struct anon_vma *src_anon_vma =3D NULL;
        struct mmu_notifier_range range;
        int err =3D 0;

@@ -1353,28 +1352,6 @@ static int move_pages_pte(struct mm_struct *mm,
pmd_t *dst_pmd, pmd_t *src_pmd,
                        goto retry;
                }

-               if (!src_anon_vma) {
-                       /*
-                        * folio_referenced walks the anon_vma chain
-                        * without the folio lock. Serialize against it wit=
h
-                        * the anon_vma lock, the folio lock is not enough.
-                        */
-                       src_anon_vma =3D folio_get_anon_vma(src_folio);
-                       if (!src_anon_vma) {
-                               /* page was unmapped from under us */
-                               err =3D -EAGAIN;
-                               goto out;
-                       }
-                       if (!anon_vma_trylock_write(src_anon_vma)) {
-                               pte_unmap(src_pte);
-                               pte_unmap(dst_pte);
-                               src_pte =3D dst_pte =3D NULL;
-                               /* now we can block and wait */
-                               anon_vma_lock_write(src_anon_vma);
-                               goto retry;
-                       }
-               }
-
                err =3D move_present_pte(mm,  dst_vma, src_vma,
                                       dst_addr, src_addr, dst_pte, src_pte=
,
                                       orig_dst_pte, orig_src_pte, dst_pmd,
@@ -1445,10 +1422,6 @@ static int move_pages_pte(struct mm_struct *mm,
pmd_t *dst_pmd, pmd_t *src_pmd,
        }

 out:
-       if (src_anon_vma) {
-               anon_vma_unlock_write(src_anon_vma);
-               put_anon_vma(src_anon_vma);
-       }
        if (src_folio) {
                folio_unlock(src_folio);
                folio_put(src_folio);


> Is this the case? Happy to be corrected if I've misinterpreted.
>
> I don't see how this could possibly work, unless I'm missing something
> here, because:
>
> 1. When we lock anon_vma's it's at the root which covers all anon_vma's
>    covering parent/children of forked processes.
>
> 2. We do "top down" operations that acquire the rmap lock on the assumpti=
on
>    we have exclusive access to the rmapping that have nothing to do with
>    the folio nor could we even know what the folio is at this point.
>
> 3. We manipulate higher level page tables on the basis that the rmap lock
>    excludes other page table walkers.
>
> So this proposal seems to violate all of that?
>
> For instance, in many VMA operations we perform:
>
> anon_vma_interval_tree_pre_update_vma()
>
> and
>
> anon_vma_interval_tree_post_update_vma()
>
> Which removes _all_ R/B tree mappings.
>
> So you can now race with this (it of course doesn't care about folio lock=
)
> and then get completely incorrect results?
>
> This seems fairly disasterous?
>
> In free_pgtables() also we call unlink_anon_vmas() which iterates through
> the vma->anon_vma_chain and uses the anon lock to tear down higher order
> page tables which you now might race with and that seems even more
> disasterous...
>
>
> >
> > Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> > folio_referenced() is the most critical (others are
> > page_idle_clear_pte_refs(), damon_folio_young(), and
> > damon_folio_mkold()). The relevant code in folio_referenced() is:
> >
> > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> >         we_locked =3D folio_trylock(folio);
> >         if (!we_locked)
> >                 return 1;
> > }
> >
> > It=E2=80=99s unclear why locking anon_vma exclusively (when updating
> > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > with folio locked. It=E2=80=99s in the reclaim path, so should not be a
> > critical path that necessitates some special treatment, unless I=E2=80=
=99m
> > missing something.
> > Therefore, I propose simplifying the locking mechanism by ensuring the
> > folio is locked before calling rmap_walk(). This helps avoid locking
> > anon_vma when updating folio->mapping, which, for instance, will help
> > eliminate the uninterruptible sleep observed in the field traces
> > mentioned earlier. Furthermore, it enables us to simplify the code in
> > folio_lock_anon_vma_read() by removing the re-check to ensure that the
> > field hasn=E2=80=99t changed under us.
>
>
> I mean this is why I get confused here though, because you seem to be
> saying 'don't take rmap lock at all' to referencing
> folio_lock_anon_vma_read()?
>
> Perhaps I misinterpreted (forgive me if so) and indeed you meant this, bu=
t
> then I don't see how you impact contention on the anon_vma lock by making
> this change?
>
> I think in general - let's clarify what exactly you intend to do here, an=
d
> then we need to delineate what we need to confirm and test to have any
> confidence in making such a change.
>
> anon_vma locks (and rmap locks) are very very sensitive in general and
> we've had actual security issues come up due to race windows emerging fro=
m
> inappropriate handling, not to mention that performance around this
> obviously matters a great deal.

I couldn't agree more. My changes seemed to simplify, otherwise I
wouldn't have suggested this. And David's reply yesterday gives
confidence that it wouldn't negatively affect performance either.

Thanks,
Lokesh
>
> So we must tread carefully here.
>
> Thanks, Lorenzo

