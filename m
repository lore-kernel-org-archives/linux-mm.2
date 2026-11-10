Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3976C60A2621
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Txk2771m
Received: by kanga.kvack.org (Postfix)
	id 3C6746B05BE; Tue, 10 Nov 2026 15:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DCA6B05BF; Tue, 10 Nov 2026 15:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265756B05C0; Tue, 10 Nov 2026 15:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E37A06B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55FE5C0A56
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:18 +0000 (UTC)
X-FDA: 85420329036.06.6805555
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50B4E100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Txk2771m;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ma2JrJdcnQvuZKA7pqkMeIbCxAQvOS7nvXcdWCB+oQ0=;
	b=4eec9GWzSNTRcYgL631AFurqC9kX5aJrPd/PGE9eNFfb3HMIdQNyUu21gi3VXGaTXEQl5m
	d5GUnOTCTA3Owi9LrRMOnl3O6gwy6rsgKHt1C4CbTHTgcUVc6TqhX6VMv9hOGVX/0y+34+
	5Krp/dJNdQZwmvM7ZxP9vk6UMDGtLLQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794342076;
	b=WvinGLeSr2wsb6bDr6522XAbNPFd6j6lKUVefrzGyRilZ2hGfY5Ozu/Uf5gdfRfcz37/g8
	ojWAlj0HIZAL23WXd/o3QDLuJVtWwx+frQBY+Rf+kwKMTAmTYeo6sVx8gAkUIBCt9Bedif
	HBU+nz0fA2Gw3JY1kzNECzjtXef7yMc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Txk2771m;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so30773605e9.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:21:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794342075; cv=none;
        d=google.com; s=arc-20260327;
        b=F9ovmSEbBlyj5CfojpegI1OkD7rt71meuuHS/vJRNxli3xpOPCOjbja1KyiA+/h7U8
         LjDXHbF0P6BguNSyC+oTh6K/RaDHOPks5mJZDMFUsW5Nr0XDwu86Q8M7Pkvq0rSLj9Hj
         DCIOqcDjfX40WZP7R6NlPpiqm2FfSBYq7pEVqagslji0s0pfAz6dBmrZfKM63X6BnXSV
         VEV30W9bcMXktjbvMJZOYVehow6PUxte1m8mHVNfHAh8bBOfOUjVqeuitcM6ifb/jt5u
         KZwG9MLeAo99wa6oDGXB+YZBoKVU7wAOrgrQmVXeT+BvRKY3+FESdobG5pyEwHP2d1H5
         9Mag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ma2JrJdcnQvuZKA7pqkMeIbCxAQvOS7nvXcdWCB+oQ0=;
        fh=EgjO6cbdSg/RSukTjdBvjPx2tX1xIfx0jF24tHqtgc0=;
        b=nudZT+qgYS1WdqyCTZ53/sJAfQpum7urwTkWc52a2cnEEjlz+KAYXVc5sc24joCqwm
         4H21YQ5KE75X5fx3YlQzvLG5IR8dZme3vCJEUn5i/m7QbatqJN/45EsVEhPyRHxJTrST
         pgNmKJ+eLBI47ZOQPms/8W6e+TFqftgpW34n7AaAigPFNMrOSTT6kiGnoMKQxSbvAE0O
         SaBAzG0tzS6T2PxK/8mre+3wV4iRcXNh16RnDOqOxAUmnGRYBBbpaKJnUswFn5UTh1xE
         ldt7KJsFyQsMYqHr6/DDEMRxOhMQ+3gmsyjpbs7ZAFylsqH1gI5ABpHrjHxrIRwCwW4J
         6PxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794342075; x=1794946875; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ma2JrJdcnQvuZKA7pqkMeIbCxAQvOS7nvXcdWCB+oQ0=;
        b=Txk2771m5+3WsYXIW17bw3wJOWSj9I9iUQoTtdPRmmRKiJIR4NtVt1AwgMxMVllbE2
         d46FScWZ6fv90TvM2vezBtxCe0GHo+wu15vCAkXa2KRsECaChKNzq/Xy2uW+SIchqFRo
         UCfNNuel1jLT/n4Mo9HtiV9D0WFPfNGPIB+uSDMwo2j7m92L4I5/2f12uxsbFrnE+lLK
         rdmlgyO0SeYNIbFRX9RHJC8aNA1y7mF8N4Na6fbfi9LSeIjcyvcuOv7gH0gFhEYsmduw
         EvjV1yQ4XNCnrUcamyy5wndRqQtokkZdtnxj4pQPyy24cLTOKODmLAvM+ZLEybWocxJk
         z/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342075; x=1794946875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ma2JrJdcnQvuZKA7pqkMeIbCxAQvOS7nvXcdWCB+oQ0=;
        b=MY1cD4zD5alYRStTALmqDEi4AZAA+GgxpiVkuH1NTNqw8BlAdQuTJIHP1MQP4Hyhvi
         sPZyVLwGy/zOav7DVnAgxtFHoH7MWz0bB0knNlY7SUJMs5NyitQTm2MN1QLQy7Z0zX+F
         APrqfSvv7Bt14D+TiGTEKtjjljL6DG6zZrzfnHf7uo22EU+xeoQUFUtkHv5yKf50NjoI
         hgbEBwfr+rzZDy5GGFV/FSckUBs7YCy1MmgGCbFI68SvwP435ZFN2eit93a8elKpsmQ8
         qBixeg59zO+WrIeIJXnBw4uxfn3vGl+xSEL1PdxAK/PYakcYAmqnB4tUR1T5st/T0Z2S
         YoDQ==
X-Forwarded-Encrypted: i=1; AL+hErGE/83OPkXEhrcAKqD5cuRBphlsrG+HSxTT/gd/xPr2GjU02Ya8vQrDcc8LaioTUhVCHxQk9Y15gw==@kvack.org
X-Gm-Message-State: APuU4Z92nniKAx7b+CZRACfxNmqXSmvjGq2oK7pdVjm64GbNZreRMqI7
	a0beB0X0NTt/O61B0LdiKMnRxqiV+OLn7C3S7Vt8Ru7LQXtAO8x88JaOynFRxSovrBPEwUEPv49
	kual7vQnaDz+zuqKJdSbUa/zclh7idRg=
X-Gm-Gg: AYBFou2zgNG7gAdeabRysOxBXjAkkyapKCg+6K+SqjYA4L4n+zglPND2R+4oooYXxvb
	ISO/rPE2ZbO4YTIQf+qs1nl6lKTC6ZTKaOPQog1rctWK4kDStB94Cpx6QvMt3A5bZNvlScZHwvT
	FrRKbAz+2+D5dLNLFFmx/+KaTp1zD3ExhE6UAcnDR804bWkamS6DFYTb+Ua9wBkVSdKWru/QauZ
	VpRz3TZT8UgJ8jcvrTXnpQtjSTpl/rP+I0XhxW9OAeF2drK7sek1jvT0a4O3JnmJ6qi/OHPO0BW
	tQXVPjroCAS1WdkBrQuy9PXHGAbfv17cSqkUFC6XeSAVTE6WCa/43o0v3sA629PRucU/yhY6sBO
	ggW1peaYexvKbFyEd/5HKgtqIuyx2e9eqR5KnM2t5fa4uobhth3uM1Ncl8Waljo2ZqtudL4lcF3
	yQtvkYoW/JIBH6Snygeg==
X-Received: by 2002:a05:600c:8b21:b0:4a2:10f9:37db with SMTP id
 5b1f17b1804b1-4ba0936c8a2mr3724185e9.7.1794342074509; Tue, 10 Nov 2026
 12:21:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109220958.2071687-1-joannelkoong@gmail.com> <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
In-Reply-To: <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Nov 2026 12:21:02 -0800
X-Gm-Features: AclHuK9ZMZb9y2hx_YlzKs9zG6I--WldmkvYSjYP3qxKZ9WTXewS97MBzXjRXyE
Message-ID: <CAJnrk1Zn4xvO2ySmmgk3vqXUKwz5TPHMWtRdKgma8icWsug9Vw@mail.gmail.com>
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>, SJ Park <sj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tm8e4eo4n5m6mhjrbaxpzpuhzquzk8oa
X-Rspamd-Queue-Id: 50B4E100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794342076-718269
X-HE-Meta: U2FsdGVkX19Ycb7MoVi1XFj3wF8n+NLhJHFUTjgqxdupGKloEHkd8My1HyKe7DKVdvLxQVHjJs1mbyI8as5AXeuPCsKWM7LRtz1Wkoks1aFFPSBbS+1mh82Up1bVvaPhgHs6atyPJInajAizbjNReyrBXjK+/T7l0+3dhwvqGEF1WHbA309vQFPErj0sQxcAVFuzD2o0WuSEyI0lCYrzvzYAhOHKj/KuLHXG1bJHqRMjAP1uWwgzqbqhEqsEhL9FzIAx3ku4TZO39NQ0dRPYT1/I6oRnsXMko0jmCBIknwGsXnhc6FdF1BpopUAay/ocsjQYlt182LsOlYW3QGw18egVwXi1bn8ERE05J5jml0q7Et5PjAiVWedWHFa/uaRWV47rmkN9CreJWSB84Jz/sXPNGKXfb5F/db4kqiCFm8JGC09ucwUV5NgF+c3hSj3C4j/F/E38Y0S8QglijqwopZYLDHKSkCaMExFc04u3ua0JQfdLfLmUOK9/Oq+PeuBApXy7OMliqaiviDmeSru8fjfWZ8gfk6gkjRynYGcmBsGPtZxgTNt54PfmxzhupRGD+gWVudELcPbuNWaImy8leCO0gU/rauseQ5Eno/uP5gBGJEtjBGTNUQ4ciX1arr8Odfvu548b053KfsyK93wUZ5ywCpJVQaJfhEBf4fuIAUM7TgoFKJDOe3Sonebo5LHCZJF4P+83aIma4/dMgnyCEDhs8/AuzEs33XcGkPVqB59okgTCdL1agaVCdCXFCW7hGqmbLR63MorvDADiW962X9VsGcm5oNJtv/GCusDWca3PICrIZq8rzusS248hEQQrS9Pym3fugUMlJ+klKkVtbFNM3MvnXPEPBzYopib9rO5fmhkpLxpqEm1ocvl5pl1d8tkN+MGT7tImMZ5f0QnriSJvwlWVHc7KnOj/Xxg554XnC3vsWkfZiL7+FNA9yDh2coWB2eyqHYnCD9vwE0Q
 z9WfRiV+
 JG21ttCaCHJSjgqH8SGxISmnaKHJUiBDw0eg14eeaCw3DdqEZtZg/7+xvlgr5Z8oqoVlX+OwURKalySGBwXW3nk/ulfaWC7dJ9EktGgJlgUcy4CL4Xew4LUzroTgRv6oCzzFtgYAQcP0vbnWk/BrLofavwBOk9pLr3FN0jo4/y7nzSJ3jZhW8unLGFxRYG5Zx/T4z3eoB1a8X3UUJh2HvZ5YhgG2nN5Nja41h3jf9E67G98MB9TmU84xvSXcdQEVDslIBFB8O3MMhGNsMDePG6WtC+ZlmHQVe0XmCf1drrnvWrTLsB8tNF7ZTuF2mvM5Vc40DiMfOgLv0wKBsV7zAXWi+Sgz/CEHGJzgPT/yHlQEi8qutYCQftIvVP/eG+oe5qGexuvjrRidvmObWi2uK1jh4TTaXFM9d2L/SF1SFtk0RDxtlupV1V2afy9mINerJkT96IZwKesTy/BVbD0cpMuVi6k9X2ZNDMJNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 3:49=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>

Hi David,

Thanks for reviewing this.

> >  - A folio whose split fails can later be split for no reason. If the
> >    split fails at folio_ref_freeze(), the folio is remapped but stays o=
n
> >    the deferred split queue marked partially mapped. The deferred split
> >    shrinker then splits it without checking whether it is underused,
> >    breaking up a folio that is fully mapped and possibly fully in use.
>
> This is a similar problem I raised in last year's LSF/MM:
>
> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=3D&files=3DLSF_MM%=
2726_+Deferred_folio_splitting.pdf

Awesome, I'll make sure to add in a link to this presentation in the
cover letter of v2.

>
> "
> 2. THPs erroneously detected as partially-mapped
>  * Failing migration/split/eviction after stepwise unmap
>  * Remapping the folio will not fix this up
> "
>
> The news here is that we now copy the state to the new folio and can
> consequently split the new folio.
>
>
> >
> > Mappings replaced by migration entries are not really unmapped, so don'=
t
> > queue the folio for deferred split when try_to_migrate_one() installs a
> > migration entry. Pass a flag down to __folio_remove_rmap() and have
> > try_to_migrate_one() clear it for those PTEs only. PTEs that it replace=
s
> > with a hwpoison entry or discards because they are unused are really
> > unmapped and keep the current behaviour, as do all other callers.
> >
> > One consequence is that if part of the folio is really unmapped while t=
he
> > migration entries are in place, zapping the migration entries does not =
go
> > through the rmap, so the folio is not marked partially mapped afterward=
s.
> > For a split this does not matter, as the folio is split anyway. For a
> > migrated folio it means the destination is not queued until a later unm=
ap
> > notices it, which seems preferable to queueing every migrated folio.
> >
> > Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped fol=
ios")
> > Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on deferre=
d split queue")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org/
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> > This bug was found by Sashiko in its review of the mTHP shrinker series
> > (https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/). T=
he
> > migration / rmap code is still new to me. This patch is a fix with the =
help of
> > AI, so I'd appreciate a careful look from people who know this code bet=
ter.
>
> Don't we have the same problem for try_to_unmap() in some remaining cases=
?
>
> See below.
>
> >
> > This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 fully =
mapped
> > folios through the split_huge_pages debugfs file no longer increases
> > split_deferred (was +64), and migrating 64 to another node no longer le=
aves
> > nr_anon_partially_mapped up (was +64). split_huge_page_test, migration,=
 and
> > khugepaged selftests pass.
> >
> >  mm/rmap.c | 29 +++++++++++++++++++++++------
> >  1 file changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index fa34e1ccbd8f..e5d17481c0c0 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *fo=
lio, struct vm_area_struct *vma,
> > +                     /*
> > +                      * The folio only looks partially unmapped while =
this PTE
> > +                      * holds a migration entry, which is later turned=
 back
> > +                      * into a mapping. Don't queue it for deferred sp=
lit.
> > +                      */
> > +                     may_defer_split =3D false;
> >               }
> >
> >               if (unlikely(folio_test_hugetlb(folio)))
> >                       hugetlb_remove_rmap(folio);
> >               else
> > -                     folio_remove_rmap_pte(folio, subpage, vma);
> > +                     __folio_remove_rmap(folio, subpage, 1, vma,
> > +                                         PGTABLE_LEVEL_PTE, may_defer_=
split);
> We will not add such magical boolean parameters. I have a patch to just p=
ass the
> rmap flags for a different purpose.
>
> But the whole thing is rather ugly ...
>
>
> You should probably look at
>
> commit 354dffd29575cdf13154e8fb787322354aa9efc4
> Author: Barry Song <baohua@kernel.org>
> Date:   Fri Feb 14 22:30:14 2025 +1300
>
>     mm: support batched unmap for lazyfree large folios during reclamatio=
n
>
>     Currently, the PTEs and rmap of a large folio are removed one at a ti=
me.
>     This is not only slow but also causes the large folio to be unnecessa=
rily
>     added to deferred_split, which can lead to races between the
>     deferred_split shrinker callback and memory reclamation.  This patch
>     releases all PTEs and rmap entries in a batch.  Currently, it only ha=
ndles
>     lazyfree large folios.
>
> Batching resolves the problem in the common case. For the remaining parts=
, we
> should likely just check in the deferred split handler whether actually
> partially mapped to then clear the flag if not.

This sounds great. I'll look at Barry's commit and rework this patch
to batch the unmap, and I'll add a patch for the check to cover the
edge cases.

Thanks,
Joanne

