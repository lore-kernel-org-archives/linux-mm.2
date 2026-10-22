Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96263606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kMy3VULZ
Received: by kanga.kvack.org (Postfix)
	id 08A676B02A6; Thu, 22 Oct 2026 17:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C276B09CE; Thu, 22 Oct 2026 17:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93E06B09D0; Thu, 22 Oct 2026 17:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0EFD6B02A6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:19:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 822251C2E48
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:19:20 +0000 (UTC)
X-FDA: 85351528080.14.BB00376
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 942DC40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:19:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMy3VULZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792703958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3k78ZLZiyk9GODqNKVNMBZwgmj6EtW4p2/GpEyhS5k=;
	b=uXRpA75LCfNlRBj+At9YNL2akVxwxy1qkeqJJsO6CR2zc627gE1a646n+JBNJHKRGSU6J2
	kPhndg57WRxPEVe3cCUBYGCfSp2CmDv/I31/ugU0YTFP7+vQAJlS+S8nuAx82ZjAv2DYS3
	YFrywOZENRZhVfbcH4t+pFA1wZkbgXk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMy3VULZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792703958;
	b=upuwZzcoyV77PT8f/MMpJBdBQCcjzQ34GAjY+IYFb29cNhgmko7IW5xTiXW4hEEidOOdH+
	bwsS4s7Pz4L6atKJWLaVgfOK8tkE/mzqon8wTMTwO5lH3pX/H1Blql/rwvZCnYmbU89IkV
	mazkYCKQlw5DF55onxQlXluwELctkKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB53943FE7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44601F031EC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792703957;
	bh=T3k78ZLZiyk9GODqNKVNMBZwgmj6EtW4p2/GpEyhS5k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kMy3VULZbphqL7iPhLqeTx9EzvhqrBamiLgDgRxnDyd6zjcCmSD9pbrfkXI30xug3
	 aCGhfOcfgFaDoQ6WVYtWXX0rdejPMfarVCwB2wITskPzS9ThqjLh/3CI8NykivzDCP
	 A7orY7/cfqZ8kTH+mso+HLDF5MZsbeVumfXf7meGF+HszLtws0513mMHeKJTEmqPWX
	 mhfE0Tw0OsoHfnbqIrefqYGyvgrq6oPbxjw+IVXJigzhN/IR55sFskm9YEQsKI7djl
	 gc4DGyskOK9x4ZS0zOP2Ez5tQb0TiA53xVl21dGFGUpvn2YsIjmau+9xxwz750TaV2
	 bl0ezCUwbd8qA==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f1cf92c9eso25015385a.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:19:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByx08GNDW5cVm2rqFXwUOQHeiBq4SPDA4uTpEKf0VfhxjwOXLrlokSC896Ht2XDUqVGZjaPYAqy4A==@kvack.org
X-Gm-Message-State: AFq9FYJ10gPy1bwqbI0kdPMSZQdcO3/0cNRLfrd8m9t5ySPrOZWKsASa
	nlUsHaePoPNjUXt3SuNbrdBDDYpivnOy+LIr9UCBYR3fhb1bUYHfVLfh4YatCSMc6tXngKc1ZMy
	ZQwRYFb0ZF4tS+daQwnTKLpSxGsEF4ao=
X-Received: by 2002:a05:620a:261e:b0:93f:2658:7e54 with SMTP id
 af79cd13be357-93f6f54d44emr122297585a.3.1792703956938; Thu, 22 Oct 2026
 14:19:16 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
 <20261022102726.56682-1-baohua@kernel.org> <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com>
In-Reply-To: <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 23 Oct 2026 05:19:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com>
X-Gm-Features: AclHuK9j6Sq7bDCxc6TVPv0MaH-O7v3jJE353lVb3gr4xcVRJVBmmqL18xwlDFw
Message-ID: <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baoquan.he@linux.dev, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuxiang.277@bytedance.com, 
	ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 942DC40002
X-Stat-Signature: ee7dh53jioe1ie98t4rtop14mfwiaw4j
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792703958-467950
X-HE-Meta: U2FsdGVkX1+P99Zc+Z//V3pRmLf4b/h8m4FMdHH++97zhbmIt2TKjYHN67iDgnYs0YfFq2lW9Fpu1HWugbzxK1Kyobn9O3luqzSuVKM6Qz5Rub2Ud2Grz48CSGch8JspFDYl9NiUM9eFTuNfMmyAmsxzORNmQ7dXqjkensGBCFxN/6QOy29zzMVyBt08IWR69L1QrH3Gg0dnbL+cvDQGNzl062nzsLU3R3qGhHk+j8SV0OpzdpBaGP+DOYkvU0eBWmQq2czmBR1mgG9bvKSZQGKvdTAKQ8tONLb/q12CwCQhmCEuvyxvwGHu26jOJwhuv7XMFINTmF9nGkG7Gv4datVkkOUp81QYAk9H3jwkh9EzCsKQdbn9ffWIPgsbrSXGdJVyL9dj8s+z4ijwz6tOSNwFq0Yz99mmPnoEGyQsR16B/djehWNaoPQdCX1xXOuFi5+9xD4lL7bnFGF+Jb9HBcBIDqvdX+gsO79Zocj74bb+PcWPFMsHZbhLKuSBiA7R35RwaWAuMJV9XeB0cgo0rZI6LJqAzKycOj59KwpXD17QhaX41tJSmoxReymwo0KlmHPWcUlxnP8LK0bLSFZMSEWXtgXbNdOy73T0yUOGyyk0FPII6rm06kSf+dj1fy7D/8bEMT3B//1sdLWnLAnSCepWyaTiyDyyhD+CTTBOEZyR7CKCR4SHWG/NkSpZRFTWqfr2Dw/wlz3sCJPc6UcDs7//m0Z7IcHnM40gMZ6C7ROMysO56OUmNx8wclZ6m2NRyYfXknQGyyHaYck7oFmZgabJhxT3XYcVvoqkIrPe1YK77Ta8rLMnGvIc6vSnrZvlRnY7R34yY97Fdp3u55vBLxfRlkoQlex7X7ubeQYyDOndz0qOeWTZC4Zb9ObHQGWR/m/FJYUryx4fDeGq78Q47wRZElWyz1X4VGcpClwnQ/MDRf0uOWogo0tWLxnAH1se4Aa+KDDReKUVPiulvIS
 fiSHmyiI
 ahc2d8SpEaOpMMjzkrC0Ngf+VW2KEwOP5t4x7dtP7f4lE4cXHS+OJ9insKFxhBM+w5H4nbKPpQaKSq5e/6U7q9YiXDgjjGxt7pcqLnfThDHRd+VocxYKzcQCgAewZ6LUkryoiVeoDS/XH4e/PEls4q8QHlxDPVUPyd9OxmwGnKrLn5FD6cUiEryTiecCNYIt+PXEZjV5dc0WPGnWkyELI0xygZc9QTWreclxwXhVPlK6oS5ZaGL9a32XpVnILBkJrgm490ltVE4Nla8yNln++8ob0PagpDYojLWWqrsxeNWk5dk3v7Aoyj/CQEmm3rTJGcF7KXtepCaDXQLTg7FIugdBtxF9yRXy4UzR7awhUXfXWeJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 7:26=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
[...]

> >>                   }
> >>
> >>                   if (should_run_aging(lruvec, max_seq, sc, swappiness=
)) {
> >> -                       if (try_to_inc_max_seq(lruvec, max_seq,
> >> swappiness, false))
> >
> > This is quite tricky. If we pass swappiness=3D0, anon aging will be
> > skipped. Do we want that for GFP_NOIO cases? I mean, these are not
> > real cases where anon aging should be disabled.
>
> No, we have real use cases where 'vm_swappiness' is set to 0, which
> means the workload never reclaims anon folios. So in this case we don't
> need to age anon folios.

My concern is that setting swappiness to 0 for GFP_NOIO also skips
anon aging, making it behave the same as a real swappiness=3D0.
However, GFP_NOIO is only a temporary state, and subsequent
allocations may not use GFP_NOIO.

> > static int should_skip_vma(unsigned long start, unsigned long end, stru=
ct mm_walk *args)
> > {
> >          ...
> >          if (vma =3D=3D get_gate_vma(vma->vm_mm))
> >                  return true;
> >          ...
> > }
> >
> >> +                       bool force_anon_aging =3D is_force_anon_aging(=
sc,
> >> lruvec, swappiness);
> >
> > Adding a force_anon_aging argument to inc_max_seq() seems like
> > quite a burden. Maybe a cleaner approach is to pass sc all the
> > way to inc_max_seq() and let it detect GFP_NOIO cases itself?
>
> OK, still look good to me.
>
> > BTW, I guess we don't need to worry about swappiness at all. We can
> > simply bypass anon reclaim?
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fc823fe3bd1f..fa6d9860156d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4903,6 +4903,8 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
> >       int skipped =3D 0;
> >       unsigned long remaining =3D nr_to_scan;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > +     struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> > +     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> >       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> >       VM_WARN_ON_ONCE(!list_empty(list));
> > @@ -4910,6 +4912,9 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
> >       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> >               return 0;
> >
> > +     if (!type && reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> > +             return 0;
> > +
> >       gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> >
> >       for (i =3D MAX_NR_ZONES; i > 0; i--) {
> > @@ -5164,12 +5169,19 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >   static bool should_run_aging(struct lruvec *lruvec, unsigned long max=
_seq,
> >                            struct scan_control *sc, int swappiness)
> >   {
> > +     struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> > +     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >       DEFINE_MIN_SEQ(lruvec);
> >
> >       /* have to run aging, since eviction is not possible anymore */
> >       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
> >               return true;
> >
> > +     /* run aging when GFP_NOIO limits anon reclaim with few swapcache=
 folios */
> > +     if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &=
&
> > +         reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> > +             return true;
>
> I've considered this, but we'd still need to add some code in
> get_nr_to_scan()/lruvec_is_sizable() to filter out the anon folios for
> GFP_NOIO case. Rather than spreading the logic across multiple places,
> I'd prefer adding a helper with proper comments to handle the aging
> issue, like the sample code I showed.
>

I'd rather we avoid hacking get_swappiness() any further, TBH.
MGLRU's get_swappiness() is quite weird, and CLRU doesn't have it.
I hope we can remove it someday and use the real swappiness
everywhere, while handling special cases based on system state,
just like CLRU does.

Best Regards
Barry

