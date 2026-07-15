Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802BEC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5266B0088; Wed, 15 Jul 2026 12:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE166B008A; Wed, 15 Jul 2026 12:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC326B008C; Wed, 15 Jul 2026 12:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBFB6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:32:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA6501C0173
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:32:51 +0000 (UTC)
X-FDA: 84991554942.05.75FFD58
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id B26E54000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:32:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NazWJ6ZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784133169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6I7Lcnt8DLXO66ZlyLhnbgPF/Qt7CMHhIJMJAFFWN4=;
	b=7eS0Q/u6K5agz4tZyD/oPiYlX9iXXEzum5MVpcX2HAQdbEhyKcNyUPSGHkYSdY3OXtI+qo
	c45QZ87Umugl/cyCNMGH70kQMZ6eMsiS05r95cau1BEIBbwXDiIEdmahA49unPl4tVTlBt
	Oa39N+DNctWH1AZeKU2LHJcqEEIfu90=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NazWJ6ZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784133169;
	b=KV9Z1l5zIcgTyhg3RidcjybdUeHNaYChvUghMla0EBROfi7V4kPLPhGk41s51BoWu7zhu5
	1mE9zP7euvBwYeQfCfqDv3r6Uo1jQNlfqomFsVQCWR8Q1MZwv2sN9a54t5Gg36j71M41SP
	BoawejwiJLI9/0WC2QhtPrb+PxtRHnQ=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso6107581b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784133168; cv=none;
        d=google.com; s=arc-20260327;
        b=KcZMML4U7vYxZC+bQ6xYyaHtF94QX3NZJcbIQmCYie4B4fUwOxNf6rhiS8mBB35eA0
         G2Hm4YHWYurl3Pn3vT2K0kQol9W2UqXzu/COH3BlxSIBV3wZJyU75S+wSzqmVnY8AyRU
         lyFPI+guJubW3GfvegC38Q+bdXSuJvSJSMzJVp+C2kw2Sfdt81Iq5OBUdgwu+HRGrVw4
         4o9xw9Smv9a1g+vKogYE95xOMV3e0uKOjx+Hb2jsaqdxUnpviydPDynNoJz/mqesib/q
         CQ/34s7eRJG097Ett7Tk6CTeUdY0rrVaxsNm6vyxcEJQSWk0xQxfvdjWWPHZW785egJB
         A4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E6I7Lcnt8DLXO66ZlyLhnbgPF/Qt7CMHhIJMJAFFWN4=;
        fh=BTxB7j5/5s6H8H94vGoTW6MvcMkJL4jSccpL/qwXSPo=;
        b=S1a6LnHi2qarkG5boYYI5MLqX2vl1pYPqssTC0MpHAKsqSmadt1bD5Azujse0ifQjF
         SNqecbLhmuw2L7ugj2Zvho6bJENdWl/7w1DgJkC+lnweIWjn+MppNK5bVVG1iZuoYWy3
         O3AuM58NsicpS1yQg7ZmgjT++hzYoK2R6dUiEskwIocVkdQrzObT/2iXDiCTuIQRLwT0
         YmvgYTjs0L3WCcA5nKODk7FMJd0+ndGKs7hCk/5GFUsKwFkBfi4w5gOlF0hGQd3dl7qi
         zIVf/kkm2MtoB5TOkSOkYd5TAJW49IX2KM0HPWwcqf4bD3cuGiz2K1Ix/Mo52eKTfbBQ
         eoEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784133168; x=1784737968; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E6I7Lcnt8DLXO66ZlyLhnbgPF/Qt7CMHhIJMJAFFWN4=;
        b=NazWJ6ZO+VmTsho2ET+BRBLRFQ4ajt6NO44bm5suP2v0tUjPlbXT20EVVwV6cK/jjo
         cFohFX2ZIpHYvBqUK1/AuKgiJWian9SALeCrhldViGQeiGGikScEEVCy1+g7ptAish4/
         W8yVl8pZ0h0Fp8j0po0W/k7NIftiN/yj6XaI0s8fnyttHW453R2LpPOMaPu0jiKUPu3s
         Ap4XiV7yuEFL3qpSKg1pbNiTMEFhiMLAWyNLqjhk0XulebbssqoDRTkF8fhTKXAhi/lq
         WYnL79QSDSuRMWlQkJVfu7W6AMKXpi8P+l45LggocoFnYqYg8EC8AocwH5sJISdsIO9y
         QPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784133168; x=1784737968;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6I7Lcnt8DLXO66ZlyLhnbgPF/Qt7CMHhIJMJAFFWN4=;
        b=Ofu6fdB6mfx7HNJ5ve04kQU53CzWb7+wvUYTlyRAeNxOhG5vWt99TRDBtI4AjUh7hE
         BKHouUnxSgf0gnYfTY0fQPyu/Wy0H0aq3vflB/Ng5MDjvdNjvwD8dQeBxCdy6wFXUJNP
         AAjDNbrdTX4SouWdvcEUh/h1S6nrp5lOP6OhFyYcDkyVEn5cD/DNoD3fZ+SkUn04Z86H
         TAyjqirxSYtS95fSC2w5rUoRxEq52G+djCvuxy5ZFag2Hw2wlnBJoVC9HPEkLOmGwuHX
         tunCivbcPsyJ+VrfkTXv6LZCZ4rBqBybr+RoNMZwQ8TM7QJBHFeonV2590afrZuNFk0k
         Ynpw==
X-Gm-Message-State: AOJu0Yz1yOnUXBw3wR/H1WudOHHPmVfccGrnaW/ai0tCWGW127D5wg55
	J9QOeEdKnj4oRP4carHb+rEPVQT2dbkIc3j8E88cYojulXB/tcO41mW5BOR8E5GL5L2uOUkDsNf
	P8kWbzPRaLHWZE80uQTzBD+F0tRF+OLg=
X-Gm-Gg: AfdE7cnQ5E2PlaYqCGcVKmYq2R0IC9q13ihP+qoAE0/8upYPlujqXUlkqiiPb9p8Mrn
	N+7kMILM3/wjnix23vsyD7YBY7qSSjuYUxvN/9yYqVGGfOUl91IsQ6/ma0gDDdBj5zAOvgpaPea
	3yzMMsFDoPO1sI0H4xRHnQVajG57uDgL4yXzMair0rjaT1EX3iL87oRjcBV4ngGr4dLvSe6cjUq
	FL2O2xB/W73NfZEdpcFINpqj+7hX65f8wBzcrxe8i1dASOPNnw2g+bhF2PO15oSJyN3D1ych1sT
	zK/TfYSsQ6lL4vft4ySWYBVSqQDLBA8UNIXV1FdZ
X-Received: by 2002:a05:6a00:9467:b0:845:e3e4:9702 with SMTP id
 d2e1a72fcca58-84a55820631mr5794824b3a.47.1784133168281; Wed, 15 Jul 2026
 09:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
 <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com> <alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330>
In-Reply-To: <alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 16 Jul 2026 00:32:09 +0800
X-Gm-Features: AUfX_mw8TfHkfSXVyb7VtLod2hgHDmoWUPZ9aGTZS-wnm7EzXF8K42xCziSMuxs
Message-ID: <CAMgjq7C0_++V1LRPNskJGhUheXF18dbjKen1GExDqdJLKJiEBQ@mail.gmail.com>
Subject: Re: [PATCH RFC 09/13] mm/swap: add priority queue for swap device allocation
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B26E54000F
X-Stat-Signature: erbwgh9sa5ehdzaaf6dwaf4hgu931hxd
X-Rspam-User: 
X-HE-Tag: 1784133169-398881
X-HE-Meta: U2FsdGVkX19iasEFuuTgvhYDtLSQgd9USC7yRBZxpL8Knj+Y/EnEgbR6DiWXapOYEOzvx6BNnn2jsQBTYrKdLlacn+ELZv5YgZTJWrT45vxBhBnPrFRwbg4447qHMsWlakuMPegwy5jM2CHX8EQtdVsiCAncHVQBuU6sPvF8enYgs+CRQwIQdQZuRg5zzQ43hhH0+Rus8h3OjE8nsNOSEGedTcdiZyaNcZ/ivHTSMByQs8E5jk/kiLUprLawim5AYwxowKGLVFhJxTOjU07NfD1yn2vmGJp5TuKmm+JwnYvSxyqlScIyoCwZr0t07fQjNb8mdhpAWAP0ae210YF02D9y8LjYsfKFDdSE81g0gMY8UF7porlBItalJYb9wxRHCcesR+bb7R+IrMLc1BgQwyQcvd1SooXdM3utQc9uBEx/lVOLEiqTxG8VOooME5g2rudwH10ydQlEQLSBzSE+t1ncKvh+j09Y+6qvORGVAGPQkClyQLBxIjpYpDB/SDqfDolwGsPEyTHEKhdOjBtAOsxrpmAtjBSf8IJOM4aOCvAhoQxd5VJXCyC97+jd/zkI/bFLdPn+vLRBfIRFPGWlbGu73BBgJf3L2hXAUGW/luKvhijgnL/P17LV4MnDHidGc18ENSG7OTStLdsurYX+BWDqb6dUqOu9IBeMcxn/AvgaAd6ZKZAZmyiumH4khtRvUB0M7Ksc/8Uh86oIuhzoBK5D80njpdyfDeTuGLOraqXDn/HnxPMwWyrz0OspvjWI5byHE1K3To4+s9YYFU0+3XwR+Fyi6G7UxBUOw94c7DNC7ejQrcEIvTdvXc8RA0QDJGTyuwP/kF5l139ROcVvVRTQ1wrDZW9E5kiElgiJ7xENJZ5k5s4uER6u32UjlKK7770tt8zHPsGnXTkIlThhruFytzIjvJRdMoQ2U7SrdL7TfEA/Ga+9Atew4qYT8uEV/v5ZT61AkIIkU+a4244
 wjYJneUg
 yhWfG5ugtbsb06JBxB6XfcgZJvc0DrDa5H+5HKfl5kPPaSBYrWSbqhbeEP+1ZZzsSiFXMSNSl3MKY9/NN1UWUmiOy96EykxSWfwewaspxSF2bpjE2r7FkiO2dJgb9PtiKvw8YpvkjSP8J27kN+RtvTVBcIhfuUER4WbJlJ2Uf+FHSq4eUL02Ht1+OMAjz0QUKQsCIp7M2kEk4jGXN0m1EaTqO6g2Lg29/4zw4U/ShBUvQKB7BExqxjtpXMNCvRft/6Gi1ehAn499e1lmyF379FulEDUT8CG1IeV5B5hxkcZxs/ycKLxrTaNgUGhlZHNztYRINK7i82KUB5Gk7xaeXe8zs+QnI9mjHkIpbGr8Z67rUMgVuegtK7CvaityIBEnL82fv9Dqz8Png9Z1O3+U6EgHoTSSoq1OY9mD1TGsZzEJ/6GYJV5cCYlJL8f9vmzoygdmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 2:10=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> On Tue, Jul 14, 2026 at 01:25:47AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
>
> Hi Kairui,
>
> Thanks for the patch :)
> I like the idea. A few questions and comments on the core implementation =
below.
>
> I'll share my higher-level thoughts (e.g. on a tunable interface for the =
round-robin policy)
> separately in a follow-up.

Thanks for the review!

> > +/*
> > + * All available swap_info_structs are grouped by priority rings, the =
rings
> > + * are ordered in a queue by priority (lower prio value =3D higher pri=
ority).
>
> looks like comment updated needed :)

Nice catch :), I got confused by the priority defination again, will fix it=
.

> [...]
> > +
> > +/*
> > + * The ring is protected by swapon_rwsem so updating it is costly. To =
make
> > + * the allocator and other users skip full devices faster, the lowest =
bit of
> > + * a device pointer is used to mark it disabled (temporarily unavailab=
le).
> > + * This relies on struct swap_info_struct being sufficiently
> > + * aligned (guaranteed by kmalloc).
> > + */
> > +#define SWAP_DEVICE_MASKED_SHIFT     0
> > +#define SWAP_DEVICE_MASKED_BIT               BIT(SWAP_DEVICE_MASKED_SH=
IFT)
>
> Unlike the old plist, full devices stay in the ring, so every
> allocation keeps walking past them. When the higher priority
> devices are all full, each swap out pays one masked pointer check
> per full device before reaching a usable one. That is also the
> steady state for swap tiering, so I want to be sure it stays cheap.
> It looks like a deliberate trade-off of the static ring design.
> What do you think?

Right, this should be super cheap as modern processors are really good
at walking arrays. We have at most 32 swap devices in most cases, only
4 cache lines if they are in the same top ring and I think the CPU
will only spend a dozen cycles on them. And rings are mostly
read-only; they will stay cached for hot access.

If they fallback to secondary rings... I think these devices are
mostly performance insensitive anyway, and CPUs are still pretty good
at reading the readonly arrays.

I did plan to add a ring->avail to skip completely empty rings, or use
cmpxchg & a seq style lock (don't shrink the ring, just shift the
content on full device removal) to update the ring content, to archive
0 overhead if we got more full devices, it works but that's ends up
super complex with no measurable gain.

Maybe we can implement these if this percpu reader queue can be used
as a generic infrastructure for other components, or if we grow to
support hundreds of swaps someday, not really a issue for now I think.

>
> [...]
>
> > +static struct swap_info_struct *swap_queue_get_device(long nr_alloc, i=
nt nr_iter)
> > +{
> > +     bool rotate =3D false;
> > +     struct swap_info_struct *si;
> > +     struct swap_ring_iterator *ri;
> > +     struct swap_prio_ring *ring;
> > +     unsigned int queue_idx;
> > +
> > +     if (!swap_queue_len)
> > +             return ERR_PTR(-ENOENT);
> > +
> > +     queue_idx =3D 0;
> > +     while (nr_iter >=3D swap_queue[queue_idx]->size) {
> > +             nr_iter -=3D swap_queue[queue_idx]->size;
> > +             if (++queue_idx >=3D swap_queue_len)
> > +                     return ERR_PTR(-ENOENT);
> > +     }
> > +
> > +     ring =3D swap_queue[queue_idx];
> > +     local_lock(&swap_queue_readers->lock);
> > +     ri =3D this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
> > +     /* Rotate while iterating the ring, just not on the first try */
> > +     if (nr_iter)
> > +             rotate =3D true;
> > +     else if (ri->rr_counter < nr_alloc)
> > +             rotate =3D true;
> > +     else if (ri->offset >=3D ring->size)
> > +             rotate =3D true;
> > +     if (rotate) {
> > +             ri->offset++;
> > +             ri->offset %=3D ring->size;
> > +             ri->rr_counter =3D SWAP_ROUND_ROBIN_QUOTA;
> > +     }
> > +     ri->rr_counter -=3D nr_alloc;
> > +     si =3D READ_ONCE(ring->dev[ri->offset]);
> > +     local_unlock(&swap_queue_readers->lock);
> > +
> > +     if (swap_device_masked(si))
> > +             return ERR_PTR(-EBUSY);
> > +
> > +     si =3D swap_device_unmask_ptr(si);
> > +     return si;
> > +}
>
> Tasks interleaving on the same CPU can rotate the ring more than
> once for a single failure, since the lock is dropped between two
> get_device() calls of one allocation. A retry walk can then visit
> one device twice and skip another. It is transient and looks
> harmless, and every fix I could think of costs more than it is
> worth....

You mean dropping the local lock? Rotating it a bit more might be
harmless I think, if that happens randomly, then the rotation is still
fair.

I did think about keep holding the local lock during the whole
process, but making this unsleepable is a trade-off and reduce future
flexibility... the local lock of the cluster below is already causing
some trouble for swap table allocation so I hoped we could avoid that.
So far, stress test didn't show any fragmentation issue.

>
> Unless you have a better idea, how about noting it in a
> comment?

Yeah, we can definitely doc that more cleanly.

> > -/* Rotate the device and switch to a new cluster */
> > -static void swap_alloc_entry(struct folio *folio)
> > +static int swap_alloc_entry(struct folio *folio)
> >  {
> > -     struct swap_info_struct *si, *next;
> > +     long nr_pages =3D folio_nr_pages(folio);
> > +     struct swap_info_struct *si;
> > +     int nr_iter, ret;
> >
> > -     spin_lock(&swap_avail_lock);
> > -start_over:
> > -     plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list)=
 {
> > -             /* Rotate the device and switch to a new cluster */
> > -             plist_requeue(&si->avail_list, &swap_avail_head);
> > -             spin_unlock(&swap_avail_lock);
> > -             if (get_swap_device_info(si)) {
> > -                     cluster_alloc_swap_entry(si, folio);
> > -                     put_swap_device(si);
> > -                     if (folio_test_swapcache(folio))
> > -                             return;
> > -                     if (folio_test_large(folio))
> > -                             return;
> > +     percpu_down_read(&swapon_rwsem);
>
> The local lock is only held inside swap_queue_get_device() now, so
> the task can migrate between device selection and
> cluster_alloc_swap_entry(). Then rr_counter is charged on one CPU
> while the pages land in another CPU's cluster, so the pacing of
> one cluster per visit does not hold anymore.
>
> Since you want the loop to stay sleepable, how about
> migrate_disable() around the loop?

That sounds like a good idea to avoid a potential race. I think these
races are harmless though.

>
> > +     for (nr_iter =3D 0;; nr_iter++) {
> > +             si =3D swap_queue_get_device(nr_pages, nr_iter);
>
> When a ring has a single device, which is probably the most common
> setup, the iterator does nothing useful. Would a fast path that
> skips the local_lock and just reads ring->dev[0] for size =3D=3D 1
> rings sequentially be worth it? swapon_rwsem keeps the queue stable, so c=
hoosing
> between the two paths should be race free, I think.

Ah, that's a good idea indeed.

> >       del_from_avail_list(si, true);
> > +     percpu_up_write(&swapon_rwsem);
> >
> >       /*
> >        * Swap allocator doesn't touch si lock, so looping through all
> > @@ -3042,6 +3375,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
> >               return err;
> >       }
> >
> > +     percpu_down_write(&swapon_rwsem);
> > +     swap_queue_del(p);
> > +
> >       /*
> >        * Wait for swap operations protected by get/put_swap_device()
> >        * to complete.  Because of synchronize_rcu() here, all swap
> > @@ -3062,7 +3398,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spe=
cialfile)
> >       if (!(p->flags & SWP_SOLIDSTATE))
> >               atomic_dec(&nr_rotate_swap);
> >
> > -     percpu_down_write(&swapon_rwsem);
> >       spin_lock(&p->lock);
> >       drain_mmlist();
>
> synchronize_rcu() can take a while and it runs here with the write
> lock held, together with wait_for_completion() and flush_work(), so
> a single swapoff can stall all swap allocation during a little bit long t=
ime.
>
> Only swap_queue_del() and the final teardown seem to need the write
> lock. If my assumption is right, how about dropping it after
> swap_queue_del() and re-taking it for the teardown?

Good observation! I noticed we could tidy the locking scope, I skipped
that optimization for the RFC :P. Swapoff is very performance
insensitive IMO, it will put a huge pressure to the system and IO, so
an RCU sync / flush hardly matters. The design is heavily optimized
toward readers (ordinary swapin/swapout). But a tidier implementation
and optimizations are definitely great to have.

Thanks again for the detailed review! I think this can be rebased on
top of your tiering work, there are some conflicts but nothing
fundamental, and I think the ring design actually fits well. I've been
experiement this for a while so I think better send it out to plan out
the next steps, and this series can be used to optimize the tiering
alloc as follow up.

