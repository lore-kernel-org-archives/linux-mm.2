Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01A0CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E938E6B0096; Mon, 12 Oct 2026 14:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44066B0098; Mon, 12 Oct 2026 14:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D338C6B0099; Mon, 12 Oct 2026 14:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD30F6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:25:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 447A5140E0C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:25:53 +0000 (UTC)
X-FDA: 85314802986.25.9A55A9D
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40C1D16000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:25:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2rQeVHj;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SUJUal26+RHlkQbLL0tjA85teB7QUkijOZ6j6kC4gY=;
	b=nKxCkmV/tk1csMeyTke+n9NFp23USaKcFUTwJWmcSlFTltPvmC7gfL4X7eJiOLMa/2RNgD
	akZTqKR6GiqwIxOg/S8s1vBybSoMCLZ1AuLzc2NhabuegGgqmcEttl7Deo9KE14UCKPvCh
	53ffpjRhTPUQffquaEdzZQyzT8wReAk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2rQeVHj;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791829551;
	b=0Okrvz2maIPPNsQHxugscJsyrmhm7w98+95klk26IUfRhAhjisuPLo7D5F/Ag++cbLfvbi
	1aOpcK3mddTk9xQe2zTAChnJbFDQmyukE0ZUs2kC9kkYlWx3LmAGZyFWGckLMqDlwe86dx
	b+v1/ZvbMDE1mF9nRHBc/j8fYTtRwyA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b170129413so3264904a12.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791829550; cv=none;
        d=google.com; s=arc-20260327;
        b=cxwWJo4PsfQfwbkMduTSIRHeT7Sc5aUapxrMV76dEJksZB21H3Q4x70GoM0RfyzYk6
         CyaqxNQFVNeqPKCNXlaxf64VhEUykeMBTZiSBMefinQAgbNscbgStr/2u6MOAm1ZSgJo
         RhJInx+Bl1DT5u1xMkgoo2RbcEeuWuU00sj17+kRg4CSz+h+rIFTwvi5SnxLuYNZyejC
         nCV2CqpyqNDysSpQBJUHfaJswb+FvLaL4qpUb41DJ/HvbPhyHcyB5LxMnzdoDChEiQcs
         W/DogG615FaU0fiXXVqaQMeC7rqT6Nd64yx8fwtshDcRwAiSWla8EKIRxlSy/AO4zE3D
         9krw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4SUJUal26+RHlkQbLL0tjA85teB7QUkijOZ6j6kC4gY=;
        fh=fIcsTFmBQqgI91CPRhXYuLXur6IAUupIsOeQc1bkNPo=;
        b=Ry6YHlRl/KcBMfSCOhG/obwGLKdDst9cg3rdfeSf3zaA4VrEWGE5Cn2QQkSvLAtdxe
         CsvqTGu6MluH+EzoDmc3Occ7oFb0thDkLUpT4IEj7LNXPOvU6tCfGh7NjBn6IYtbJTcu
         VAxoJ2MkGiqKLxPZhE9HNYTa84GGs6XK0GJKa10x9Pjxmrc7m0MBSaEsRkwCpjdBuV1l
         gHA5XIEL2moGIckEuydP4lQ9wiDmnn51tlJ3K6o4i1bf9bhILxSPYowgv5/uP80+T+yK
         IRXsIUTIClM1o4dEA4GfDN1FpZ/Sp7sZEcXaWLs7stBs3cFggVSNuthOFRxD5zIwSCul
         uhYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791829550; x=1792434350; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4SUJUal26+RHlkQbLL0tjA85teB7QUkijOZ6j6kC4gY=;
        b=N2rQeVHjTJV0f9DjMLQy9DSSLb5/DjdFtHrsPgeTl28wSukH/7aFFpq8f9983T/cYv
         CVoVAxeV64wA72TqNo6oneA1AQ+KZJjGBTXVi7rs+L+fzJwFXgbNEh2yrzP5thmAwRpT
         TonNcWiT77VtSpVTQUQKQiH3PXC+2pBKDW/5daOyOlQR/ovXJc1ZDwT1TTfDcvQpP7a4
         HbyEoXl6Wa89Ko0mgN5I8ZjkDIC83cgYwZga6JQiMjtPho73YTB21/RttgMObBpSNdTz
         90q9Mbwu1rrTNPs+YeNQnfifOApKE2w4dt1SRw4FD6cyARgT7PR/vLlWiEw00fNPpq+k
         Gvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791829550; x=1792434350;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4SUJUal26+RHlkQbLL0tjA85teB7QUkijOZ6j6kC4gY=;
        b=Q3ucSQLIFQUtT4CQj30A1Xl0ceiI9teZvAhET1BhSfTDkzylPZqwzaHwtWpRfjgih7
         P+q/OQ2DodczNyo9bmvbqacAhw+5o8mJDqARSio5qM9K2lE1Y4RvCjIOOC6WGI98mbvS
         +f0XT96/54OcOGX6WzfEI1D6/2Em0DDTF8qnHo5/L875GiqbWTaeeNc+H+zWoVEbcTCi
         xMacKQwTHza70YOoShcxDH5xwygzPmxw2P9kF/sXYJudfYdwVETo5hxRprbwxZjj7ksv
         p4QHJjJJvNk4JXXZP9hE8/m3Kx4H5xcohEhmfsydPv5xKbl+eyRRyAIsWHwpuGvrG/ct
         9UuA==
X-Forwarded-Encrypted: i=1; AKwUvBykQJEdPHQQFuJ1pjjtK6lzwyhc4bnqENl4EdZwnA+Zzib3lV2zMBLujwfCzDQbFTvJfZ012amgUQ==@kvack.org
X-Gm-Message-State: AFq9FYLo9OmkLQaTUJTVd0Kx3poA3Ye+kKngoLCTs5nwK8/CQB5AQwyu
	iSe9Q4il8LIM1G2FGG+bF/+V0B4V+Hdgy5r03SF1DDVbW4PoxZEyMzB0qlQ5KreAVFdiHnCRlZu
	uOxf26J2P10CuUM9vO64z3MkRNCNvdf0=
X-Gm-Gg: AYBFou2CRAiftSNB7N1eGfEnhiEs/1c5jXX5cQOmzDsZOJS/8Uoe7mvKHfuh3j3gRIj
	6aUpceQZfhsNDIKfKowTrkAJ8PtQb3q08pAgLm3Oyg9z8kb7MFGpBzACpyjSxbefV4+Rv1rQFBK
	rX6iu4DNHL4e7gbmPwW9WwA/ew/MfEyDr6NC+X22im2IZPfD4cT19g653LMzKJ/aQeGkeCCI6Qw
	cDECSrq4WFshTxOUvnqfRdithEtOBV+LA+gPDnwNkUmPEOrU7fjG9tCnqck0Z4di6cDB+1zlgl5
	JH5n44hS6zk281G/37J6WQqm3bm8eSmgpAb7WFEqMjNXF08BQlH5GY6q4L4OL+1NGMGNn+bT0YJ
	qch3IXf2isqoz
X-Received: by 2002:a05:6402:450f:b0:6af:9de2:b1f5 with SMTP id
 4fb4d7f45d1cf-6b17c25d1e6mr9324085a12.12.1791829549501; Mon, 12 Oct 2026
 11:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20261011132227.413217-1-samarth.colleges@gmail.com> <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
In-Reply-To: <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
From: Samarth Narang <samarth.colleges@gmail.com>
Date: Mon, 12 Oct 2026 14:25:38 -0400
X-Gm-Features: AclHuK8P2jmdsfz85yovNXHcE8c2fcg-1RuvcU67aDTAS-Aolx0V7mNFGq9ZXPo
Message-ID: <CAAbz3fTZyeDL1Sy5FOxuJ8e0zgM5SJa1UKa7sk2apkaJFeeBaA@mail.gmail.com>
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000cbd051065da8d36d"
X-Stat-Signature: iw8r5b9cwriyiemf5wu1ffbrsm48dbtx
X-Rspam-User: 
X-Rspamd-Queue-Id: 40C1D16000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1791829551-260061
X-HE-Meta: U2FsdGVkX18cREAM8bSoc6AihQUIcWiV5/rG9ECuPfTyNTXY9KisSU309tPqQuUX+3WvW8OcfhoaTKhiMrN78s3qmG8fcG+a09Yv0iKup68Y6we+J/sBYj7b/oaxYxa0UT5tu64bQL2Orlw+HYcp3ts/FgH4vX0rQMJnb1LSZ6DiBZe4l07QQ6zOIbU3VjWd9MVdU3T/z3JcFEQXfFtnbtDYgnQDXKTO5uv51GpBDuqDqJvMP9llBnJeTyUSLo2cKwag/mwgRK/sbNtkm//7lXYclssAgS5I1BMVO5Rcsn6INKQB4xmbylupzMdt0BVV7NDerOFgAsAedZExwvHKC7OyHY9WwBpzTjpK0LzjfLHlLDOvkA+wOcVeQsKc+rNXK/yNSmhHNC+4IprQzIaVwqDizf4TFVcjc+UWtE7wCX7AR6SWVZUni+vCyqXNBKhHhzKjd9xpMhHx8ajpMRyhiM7OOqquYOVeoe/hwcoMV9HdT8zpLYu/45CbJNhixRnmZVxmHDFj+BS108sLZoKhqxy+w5IbcMSrhzkPRp100fhlOmuwvIbQn69m4Z7nRIsAxVop2yD2Dr975haUJHq2sDZQRSsUcjhWAc+Tejx+WlR5ooILaVrVWe8UUjB8iT2dgabZP14m9aiqqOy4joqeGMho9veibx1YwtvDaeayCiHWwsip6t/j/Ba/ufEgMxp5cldGOdkrqyjHpntXdr7ixzXxMW5kKbQ2Yw5nCjWVg4M2sO8i/G/V2acMZPBPCISa+8dT3+ax8S7wFh5VJNl8WkGk8QyorI/MTdHo1KN3GyRIEhQxXrV1ssSKfUPUkVrW9FxcKS7cGDGvxdodO4sXppqGaxyyFk/80MPWIuVHJe1cVBuJuiu716yzkjfluxJYvuvIDMkJ+uRE4ve19USccVfumKtPb+oTR3PukpBsIO5BqWI9+Ey7PrF94Duoi+SzT7XRzHs07uTqeeCpzkN
 sVMXg2kS
 n/iDjt7NklX/2n3nvKvm9YNuWZWaOpmou/XEv34cLaKa7Iw1UpusNuxw+764GEqV/y/OKE8jCcd3FWS0eN+QO6+lU7CZR68cxadn8MbtA36OhU/qJK0sHsUFag+JVwPZe+MBq/ASdqvorCc7+ZxV++XzVYD+d2gKBpWiK8WZ8k0yOEgfgL2sBZXzDTjxtEMJPxo/KZJIUfuLtCVWMPQgxzVGrD1weYhp0JiZTAiC83YfqIvkNvi00+3y7kvo1ZxZd6KuqG+IyHmYX9DZlDaVyW2K13W203f1VFMCS0YVNhgp9xS/Dk78ojHAqG8UvVnKZ+2k1kb/c/qS3hsx1wJAOujBd8hxuslEQ1t0me4f7g9RI9DpGNmNHBCVCygZO3WkIrauQwPo0oUlbGoZFdAzY8baWWtCoR5nBOpfNMa9rY30+62fKxgqdezr6fO+FfU8R0R9J4X89BWQWgvpYy6imk8MHlpspaXxCCotmj292m6D5sFie6j3XcgW9V54tZ9PSNNw9VRtaTQ0aBioTbT/PKPTJ0ZVxywc4+OHsrEZMR5fcUHwKgFzm4iVdmpqTjUpsbkZzptkgOmAMtXMDyoThhC0uSHLqLs0mSk/SRoaverEgUp2BzD6DDOHdeFdmVc6Fd0je
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000cbd051065da8d36d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks both for your review into this; I was building a structural detector
tool over page-table bit paths, and came across this.
I got agents to reproduce it on x86 where we mark a 2MiB anon THP
MADV_FREE, race a store from a second CPU against MADV_COLD, then force
reclaim with MADV_PAGEOUT. The race pass loses stores while the control
pass does not.

Based on your suggestion, can we clear the accessed bit in place with
pmdp_test_and_clear_young(), as the PTE path does via
ptep_test_and_clear_young(), instead of rebuilding the entry from
pmdb_invalidate()'s return value. I tried this patch on the bug, and the
fix holds. Let me know what you think.

---
 mm/madvise.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -426,10 +426,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t
*pmd,
              }

              if (!pageout && pmd_young(orig_pmd)) {
-                     pmdp_invalidate(vma, addr, pmd);
-                     orig_pmd =3D pmd_mkold(orig_pmd);
-
-                     set_pmd_at(mm, addr, pmd, orig_pmd);
+                     /* Clear the accessed bit atomically, as the PTE path
does
+                      * via ptep_test_and_clear_young(); don't write back
a stale
+                      * orig_pmd and drop a concurrently-set dirty bit. */
+                     pmdp_test_and_clear_young(vma, addr, pmd);
                      tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
              }



Samarth

On Mon, Oct 12, 2026 at 6:09=E2=80=AFAM David Hildenbrand (Arm) <david@kern=
el.org>
wrote:

> On 10/11/26 15:22, samarth.colleges@gmail.com wrote:
> > From: Samarth Narang <samarth.colleges@gmail.com>
> >
> > For a young, PMD-mapped THP, madvise_cold_or_pageout_pte_range() handle=
s
> > MADV_COLD by reading orig_pmd =3D *pmd, calling pmdp_invalidate(),
> > discarding its return value, and writing back pmd_mkold(orig_pmd):
> >
> >       if (!pageout && pmd_young(orig_pmd)) {
> >               pmdp_invalidate(vma, addr, pmd);
> >               orig_pmd =3D pmd_mkold(orig_pmd);
> >               set_pmd_at(mm, addr, pmd, orig_pmd);
> >               tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> >       }
> >
> > pmdp_invalidate() atomically clears the present bit and returns the PMD
> > as it was in the page table at that instant.  A store from another CPU
> > that lands after orig_pmd is read but before the invalidate sets the
> > hardware dirty bit in the live entry.  Because the written-back value i=
s
> > derived from the stale orig_pmd, that dirty bit is erased.
> >
> > If the THP had been marked lazyfree (MADV_FREE), reclaim later finds a
> > clean PMD and a clean folio and discards it rather than swapping it out
> > (__discard_anon_folio_pmd_locked()).  The store is then silently lost: =
a
> > subsequent read returns stale/zero data, although the MADV_FREE contrac=
t
> > is that a write after the advice call cancels the free.
> >
> > pmdp_invalidate() returns the pre-invalidate entry precisely so callers
> > can carry the accessed/dirty bits hardware may have set concurrently
> > (d52605d7cb30).  change_huge_pmd() and set_pmd_migration_entry()
> > (8a8683ad9ba4) already do this; the MADV_COLD path does not.  Rebuild
> > orig_pmd from the returned entry.
> >
> > Reproduced unprivileged on x86-64: a 2 MiB anon THP is marked MADV_FREE=
,
> > then MADV_COLD races a store from another CPU, then MADV_PAGEOUT; the
> > stored byte reads back zero.  On current mainline built and booted unde=
r
> > KVM, the race lost 131 of 8000 stores before this patch and 0 of 8000
> > after; a store-before-COLD control and a MADV_NORMAL control lose none.
> >
> > Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> > ---
> >  mm/madvise.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -426,8 +426,14 @@
> >               }
> >
> >               if (!pageout && pmd_young(orig_pmd)) {
> > -                     pmdp_invalidate(vma, addr, pmd);
> > -                     orig_pmd =3D pmd_mkold(orig_pmd);
> > +                     /*
> > +                      * Rebuild from the entry pmdp_invalidate()
> exchanged
> > +                      * out, not from orig_pmd: hardware may have set
> the
> > +                      * dirty bit since orig_pmd was read, and a
> MADV_FREE'd
> > +                      * (lazyfree) THP whose dirty bit is lost is
> discarded
> > +                      * by reclaim, silently dropping the store.
> > +                      */
> > +                     orig_pmd =3D pmd_mkold(pmdp_invalidate(vma, addr,
> pmd));
>
> Okay, you are saying we can lose the dirty bit that could get set
> concurrently.
> And if we did an MADV_FREE before, we might not detect that the content
> was changed.
>
>
> I suspect this found through the help of an LLM and not an actual use cas=
e
> in
> practice?
>
> Using MADV_COLD following MADV_FREE sounds odd at thirst. In particular,
> when
> having MADV_COLD race with actual access.
>
> On the PTE path we use clear_young_dirty_ptes(CYDP_CLEAR_YOUNG) which
> achieves
> the same through ptep_test_and_clear_young().
>
>
> ... where we also just do a
>
> pte =3D ptep_get(ptep);
> set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
>
> in the generic variant and rely on the per-arch variant to do the right
> thing.
>
> Which makes me wonder whether we should actually have per-architecture PM=
D
> helpers for that purpose?
>
>
> --
> Cheers,
>
> David
>

--000000000000cbd051065da8d36d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks both for your review into this; I was building a st=
ructural detector tool over page-table bit paths, and came across this.=C2=
=A0<div>I got agents to reproduce it on x86 where we mark a 2MiB anon THP M=
ADV_FREE, race a store from a second CPU against MADV_COLD, then force recl=
aim with MADV_PAGEOUT. The race pass loses stores while the control pass do=
es not.=C2=A0</div><div><br>Based on your suggestion, can we clear the acce=
ssed bit in place with pmdp_test_and_clear_young(), as the PTE path does vi=
a ptep_test_and_clear_young(), instead of rebuilding the entry from pmdb_in=
validate()&#39;s return value. I tried this patch on the bug, and the fix h=
olds. Let me know what you think.=C2=A0</div><div><br></div><div>---<br>=C2=
=A0mm/madvise.c | 8 ++++----<br>=C2=A01 file changed, 4 insertions(+), 4 de=
letions(-)<br><br>diff --git a/mm/madvise.c b/mm/madvise.c<br>--- a/mm/madv=
ise.c<br>+++ b/mm/madvise.c<br>@@ -426,10 +426,10 @@ static int madvise_col=
d_or_pageout_pte_range(pmd_t *pmd,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 }<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if =
(!pageout &amp;&amp; pmd_young(orig_pmd)) {<br>- =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pmdp_invalidate(vma, addr, pm=
d);<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 orig_pmd =3D pmd_mkold(orig_pmd);<br>-<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_pmd_at(mm, addr, pmd, orig_p=
md);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* Clear the accessed bit atomically, as the PTE path does<br>+ =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =
via ptep_test_and_clear_young(); don&#39;t write back a stale<br>+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* orig=
_pmd and drop a concurrently-set dirty bit. */<br>+ =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pmdp_test_and_clear_young(=
vma, addr, pmd);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 tlb_remove_pmd_tlb_entry(tlb, pmd, addr);<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }</div><div><br></div><div><br></=
div><div><br></div><div>Samarth=C2=A0</div></div><br><div class=3D"gmail_qu=
ote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Oc=
t 12, 2026 at 6:09=E2=80=AFAM David Hildenbrand (Arm) &lt;<a href=3D"mailto=
:david@kernel.org">david@kernel.org</a>&gt; wrote:<br></div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid =
rgb(204,204,204);padding-left:1ex">On 10/11/26 15:22, <a href=3D"mailto:sam=
arth.colleges@gmail.com" target=3D"_blank">samarth.colleges@gmail.com</a> w=
rote:<br>
&gt; From: Samarth Narang &lt;<a href=3D"mailto:samarth.colleges@gmail.com"=
 target=3D"_blank">samarth.colleges@gmail.com</a>&gt;<br>
&gt; <br>
&gt; For a young, PMD-mapped THP, madvise_cold_or_pageout_pte_range() handl=
es<br>
&gt; MADV_COLD by reading orig_pmd =3D *pmd, calling pmdp_invalidate(),<br>
&gt; discarding its return value, and writing back pmd_mkold(orig_pmd):<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pageout &amp;&amp; pmd_young(orig_pmd))=
 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pmdp_invalidate(=
vma, addr, pmd);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0orig_pmd =3D pmd=
_mkold(orig_pmd);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_pmd_at(mm, a=
ddr, pmd, orig_pmd);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tlb_remove_pmd_t=
lb_entry(tlb, pmd, addr);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; <br>
&gt; pmdp_invalidate() atomically clears the present bit and returns the PM=
D<br>
&gt; as it was in the page table at that instant.=C2=A0 A store from anothe=
r CPU<br>
&gt; that lands after orig_pmd is read but before the invalidate sets the<b=
r>
&gt; hardware dirty bit in the live entry.=C2=A0 Because the written-back v=
alue is<br>
&gt; derived from the stale orig_pmd, that dirty bit is erased.<br>
&gt; <br>
&gt; If the THP had been marked lazyfree (MADV_FREE), reclaim later finds a=
<br>
&gt; clean PMD and a clean folio and discards it rather than swapping it ou=
t<br>
&gt; (__discard_anon_folio_pmd_locked()).=C2=A0 The store is then silently =
lost: a<br>
&gt; subsequent read returns stale/zero data, although the MADV_FREE contra=
ct<br>
&gt; is that a write after the advice call cancels the free.<br>
&gt; <br>
&gt; pmdp_invalidate() returns the pre-invalidate entry precisely so caller=
s<br>
&gt; can carry the accessed/dirty bits hardware may have set concurrently<b=
r>
&gt; (d52605d7cb30).=C2=A0 change_huge_pmd() and set_pmd_migration_entry()<=
br>
&gt; (8a8683ad9ba4) already do this; the MADV_COLD path does not.=C2=A0 Reb=
uild<br>
&gt; orig_pmd from the returned entry.<br>
&gt; <br>
&gt; Reproduced unprivileged on x86-64: a 2 MiB anon THP is marked MADV_FRE=
E,<br>
&gt; then MADV_COLD races a store from another CPU, then MADV_PAGEOUT; the<=
br>
&gt; stored byte reads back zero.=C2=A0 On current mainline built and boote=
d under<br>
&gt; KVM, the race lost 131 of 8000 stores before this patch and 0 of 8000<=
br>
&gt; after; a store-before-COLD control and a MADV_NORMAL control lose none=
.<br>
&gt; <br>
&gt; Fixes: 9c276cc65a58 (&quot;mm: introduce MADV_COLD&quot;)<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable=
@vger.kernel.org</a><br>
&gt; Signed-off-by: Samarth Narang &lt;<a href=3D"mailto:samarth.colleges@g=
mail.com" target=3D"_blank">samarth.colleges@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 mm/madvise.c | 10 ++++++++--<br>
&gt;=C2=A0 1 file changed, 8 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/mm/madvise.c b/mm/madvise.c<br>
&gt; --- a/mm/madvise.c<br>
&gt; +++ b/mm/madvise.c<br>
&gt; @@ -426,8 +426,14 @@<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pageout &am=
p;&amp; pmd_young(orig_pmd)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0pmdp_invalidate(vma, addr, pmd);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0orig_pmd =3D pmd_mkold(orig_pmd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 * Rebuild from the entry pmdp_invalidate() exchanged<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 * out, not from orig_pmd: hardware may have set the<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 * dirty bit since orig_pmd was read, and a MADV_FREE&#39;d<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 * (lazyfree) THP whose dirty bit is lost is discarded<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 * by reclaim, silently dropping the store.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0orig_pmd =3D pmd_mkold(pmdp_invalidate(vma, addr, pmd));<br>
<br>
Okay, you are saying we can lose the dirty bit that could get set concurren=
tly.<br>
And if we did an MADV_FREE before, we might not detect that the content was=
 changed.<br>
<br>
<br>
I suspect this found through the help of an LLM and not an actual use case =
in<br>
practice?<br>
<br>
Using MADV_COLD following MADV_FREE sounds odd at thirst. In particular, wh=
en<br>
having MADV_COLD race with actual access.<br>
<br>
On the PTE path we use clear_young_dirty_ptes(CYDP_CLEAR_YOUNG) which achie=
ves<br>
the same through ptep_test_and_clear_young().<br>
<br>
<br>
... where we also just do a<br>
<br>
pte =3D ptep_get(ptep);<br>
set_pte_at(vma-&gt;vm_mm, address, ptep, pte_mkold(pte));<br>
<br>
in the generic variant and rely on the per-arch variant to do the right thi=
ng.<br>
<br>
Which makes me wonder whether we should actually have per-architecture PMD<=
br>
helpers for that purpose?<br>
<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000cbd051065da8d36d--

