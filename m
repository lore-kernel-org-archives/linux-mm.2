Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405C0CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090326B0092; Wed, 24 Jun 2026 20:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0195C6B0093; Wed, 24 Jun 2026 20:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC486B0095; Wed, 24 Jun 2026 20:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF0EC6B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:14:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D4FC2139
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:14:14 +0000 (UTC)
X-FDA: 84916512828.29.C1A677B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2774018000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:14:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ftr2LvMj;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782346452;
	b=lhV8XsNw5c/c7jKkIzBvnYWUiFcC8NNeQ+QwZsF7XLPUWvkBol6WfnxrnAibUlLvL/1NCo
	2YMq7w6+Tbw+ytLQP38ki4IgOAGQC4idKy2ZoqnASgFs5rZrrL4A2j14yQlxVFyzuPBIm7
	l4J6jpU0QwujbBN4jGDmpKJwAhpG7kY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQUU4QEwAFRoM46ZCAt+65nFqlnbcp63bvZEbEWuj4k=;
	b=0svBJZhhUH58j6kEAEUGUxEeKq4AKZur+phI1zO4EyBzhqMbo2OYivlvpwp+Vl6jgVPsmS
	tCqTgS6MD+/iVRuOXU/J7w1eGbjsUgqXBp/eP5NrOBKNragQRNGCTm1jgA0E3LvA2oG5Th
	JNdYhq8F01v9+hzUo7dtx3zg0Fmz4go=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ftr2LvMj;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cdae130cso8666495e9.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782346450; cv=none;
        d=google.com; s=arc-20260327;
        b=AmHTwF7MgyZxQ93I4T0WIFX3fR12KMF5HcOufRh+moyKzr5aP5maq0U9unObBDgxTB
         DU66E+wO+CaGIRBrA1XSblo7Slg04A/I1C/4vXw3Zjsn5VmzETFJL+ZBu+cZMjoVKcCo
         OogkNGyg8ZQhykV/DSHkVaDQsaq27WJmhaDYbtDSW6yyYzmDtEG0XGrLRDFDCNU5akqx
         Ij94zosWMl6QMrycXgSbhShsxwjcs+FJ0ceHMfscbHyx54wM3/fIxkwGub1mupM4eUFo
         EZvqqsRCTCkPoEF57CVdLD8/ErbqBQJumwGcMCqp5h4Gvl8zzrflZbiB0KPM3IXhvhA3
         QM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQUU4QEwAFRoM46ZCAt+65nFqlnbcp63bvZEbEWuj4k=;
        fh=aOIDtWjJbo9c1Dq5F1KFJdSBOrO3VmLUNHdRVaxGggY=;
        b=W4Doy+O6HgEqo/xzgfdiF9Gb1+qC3bOB/dBOu50OrZl6Av2+4SCu+72O4lozUM0zuE
         iPXL0sGELv7wbkstHvk7OmhNcRf1xMISs/qKtBmELEuVoPQdHzZXYw9MgHXgDl9y4Lg7
         1mu9J6XWBlYaEcz7qfdGsANak4K2WyvpPUuo7nmk8GO71COkiekPCLTyi7zc2Bh0b8CC
         v2zSe8KGLXna1LdASWm4uHObGOF8PnwlvuFITJiztjiBHrESK6nVoPiB+2RWPEy8sqBu
         utwXcG+DhVB2fUzTrtUuxsZ4KsGjaeh85NWA5xdPkVZlkkK65ftc44hZomc5UzL2QVUn
         lxwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782346450; x=1782951250; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQUU4QEwAFRoM46ZCAt+65nFqlnbcp63bvZEbEWuj4k=;
        b=Ftr2LvMjz0a2TEyVHzdLXXazakxTMgQAVwuGlXjLAxfcUizXQBVuBO3ZpSPg+SPoW/
         2o8n3GByTacRRq+sbbOIwHCUXxcTHfMPmwTpXbgKG2mVS6sFyuDWOXFpG8KNlTd3bhsm
         FBsk0lBuHlNmVnO16M0LymCFBqc0zHS29EmdBPA9My/6ZYWjC+SQmpEYDk39lX8vFuux
         nGayccbuyP0mVYI9hS9ZvKq/wb3taryjhNWn9TVgmHpOh50BtFOMRqRCdox4w4jzNutH
         PYD3MlOBlJavosD84rVVSwCvPaTA6lckL2K41EpqiiB+KBAzV2piGybV6h2rAaE7jvTf
         VDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782346450; x=1782951250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQUU4QEwAFRoM46ZCAt+65nFqlnbcp63bvZEbEWuj4k=;
        b=XH/ggusbYx4lk6DivQmKwfZhPCQfL63R6/W9OffMVetDiBJX/Pbsk4HRyn+xhxQgH/
         Z/cSY3Yu9MVJVuBn58f/Zcnc7ZUM+It+5TohArGpscoXFPx3Ebpr19URrei6QPYNOwPK
         JqdyL3970avcjVz3q5Nu6/D/EsfxNIjiuK8jtraDVnHC2Dle4NJxUvkhfT+RUZkEUhGr
         0Kh8m+d1FFmwKJQmVjuqC4p3sXICbN2uWS6PgyHp5lOt3xx95RV1p0Af4Kplh8VWF+/u
         zVwNaOlgFbSSkFbYRvzJ81PyqxlDWcQhJD7vtFVq4b8D13ZNcIp9ikq1vgz5ebbOAsT0
         o6eA==
X-Forwarded-Encrypted: i=1; AFNElJ/MGHXDk5P/rwX+eI5YpBDpK2CnJlN+DIjnMORHZP4Fpg4ozWKFoEu91wmtHwfc31mlCp3kLkeOeA==@kvack.org
X-Gm-Message-State: AOJu0Yx+GTWURFNSx1+I6iLzyxjiC5Q6KXcDWvj2Q17ip408AIOZ41S1
	kaY4z2duZ6UCe9/wItqLURx8V4S1A0/ckrgoRqQVGaYMhPvcT4O11OhowR+FYco/lqwalLsMUac
	zTi581rulveNVWZsyDGJijhhgO9nomo4=
X-Gm-Gg: AfdE7ckVZf20eVfAazhxhfRLXD+o9PYw6wGCdd+ODiRpulpVtuz1atr6tzqHzZboM4/
	iwHda6RB5+CA7BU8OZTRdn/zZtIs/8X02ypBxV6jThWEBXcPJSm6bCrLRxlkLhylJ8EMsmJlP0k
	quX8ULB1dBnqz7QK88qeSFmA5tBbQkvf6SMOOXmnyPGiOcxqfrG3FmTL3dc5NxSNVSSCyKJn4xn
	Lvs1aYTyWFWnJN+YDHVbv5kt1upqnvLM0jHsaNtLwm6Mp5tlP3d0qXfyTCfO/Ba7iUDUMkddPuO
	WNepNP+gTDE1znhN5vK41MlcHemLy/4X3IP3vpPmgGLC15TFbQSfNE4=
X-Received: by 2002:a05:600c:a46:b0:492:604b:c77b with SMTP id
 5b1f17b1804b1-49266885dcfmr780335e9.26.1782346450038; Wed, 24 Jun 2026
 17:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-4-nphamcs@gmail.com>
 <CAO9r8zPXk2eRbVcEMQDTCH1j-w241h189=p04FenAfKAjkkQtA@mail.gmail.com>
In-Reply-To: <CAO9r8zPXk2eRbVcEMQDTCH1j-w241h189=p04FenAfKAjkkQtA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 17:13:58 -0700
X-Gm-Features: AVVi8CepHOibpPdukelNQnwEdTBgwRTdcmtt33fMSa9KmP8wKp2yKEwbQKXWFqM
Message-ID: <CAKEwX=PT_ABx51--Qv9AAZwkuH+_Wp_TeiUYVQBY=1=SCf1HJA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/7] mm, swap: support physical swap as a vswap backend
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2774018000A
X-Stat-Signature: mfkjscz68bcpar3ie6rqtbh668tiqnhz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782346451-191271
X-HE-Meta: U2FsdGVkX19g+upzK+vpsdvMRoK7mVblrUaJSySTP/ZG8iq3wHn9rhmfuRWbRRwupjtVOwWA4mTICIb9afErAVoJW5+1KV7sm88hcD6jK8u002krlxNxj6LHNzTGnRS/CKrg3ymfRenMp4ykYmHWOk3k+wvLxmQ0jctZRLm1Y1iMxOqxHKqzqqj0solsbmVm2jSTX5PwgDAQR2vDE/vMTUD4XPTyKpkSQB2+YXg35DzApHZoV00PDbkFMl5gqxYpuj1IcLzFGriil8jGfpZCGEYJFyIQvSGL4lYzhYhQuzldnuzw57MdHCsmfZj2xAT4jai56aGpCYvYNU0OlWzwVAMCyX2J3ID7FtDizebOsMWTdqn08spW3xuTpcTHLWLgiY8foibHCC0ofFgg6jiAc7vAD0lEZaB/Tq3uy9tFzM9yMDsL2SQggrmibyYceRDTyFpLjgcLg1sUC2GEAjHvB0suGPKt+qjmlfeDraIPS++HTONnEjyzr9s81cPn7xCKTX6udopV7cEy0u1OORvhwRJSEi7eWtoY2XI8rRrSSUSWkiik/2f7iitR/hcVHFOqop7jwogVKrw3VqTpHcO1KrVSMJ2UerNtQE7ACqgFM87hiXzMDOHfKxyeEQNBopCIXcbRhXMOAAyec3cmzjmi+z119s8SG3moij4s7Cwr6nvBpT9259wfFGi4735Xw36pHmevYAFokK/nD4JxOdUwwSUn7alCPpKc5xMoDOGuJ/DUQPsLlvBZ5NMtG4hymcdwDsCk4yBQ96OGWX8Z2DWcEKBQ+dqFIxFTyrBmPWLcHD3mqINSpLU7274yInv+4y4ChY7vkQqM9Wgw0U1LFwvUs7CKNQWglr3QcVX+iIf8Idv149dELXiHBw1XrGXfsfOLS+37hQIxRmlN0j75J/aBLed+3FxerYTy8I6skAQGmECCkkW8LKpraEbrO3y3gIwjZUXbO1zNyZsKBXDb5OD
 o+Zbtv/w
 fkKlmvkibTzTozfUNjLroVQ/baD/dhl2QZ2rlFjxU3HrcML1XCQMEJXuax6V8q9x+Gfh7zLnKNFtX60FRVNfcBJmEKs2oDkWrmakQHsrKTtAryRwWmBz5oT9xGlkfNcEZ2QiKQCl9T+TNQcWcPTQezN8XsQT190oE1vV9svA9iwpHzx3LFNXS/DFp9GcTKBdxVc07ND4JNVyGw6QCaF8UrRnutkn10BUx+9YKVRv1tDzkjy5gCEsGaA9AZu4pgrwr0Xd62jguNkNDsMvgp5BGrO0M1elUtvewSUCM8ZX9zdwTBP9eg8egrVBMWcdbkZvNGLJcQZZbWrH6qK9offpR2P5BUuaOZIiFDPqsMAcsvVyb55qMV+irQyrW8Mx6bp9kmAE4o+XqRdBbJey4nCFC0Sv7CvP+ymrTsLhTIoeFm+j46rY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:02=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 466f8a182716..5daff7a25f67 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -993,6 +993,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
> >         struct folio *folio;
> >         struct mempolicy *mpol;
> >         struct swap_info_struct *si;
> > +       swp_entry_t phys =3D {};
> >         int ret =3D 0;
> >
> >         /* try to allocate swap cache folio */
> > @@ -1000,16 +1001,6 @@ static int zswap_writeback_entry(struct zswap_en=
try *entry,
> >         if (!si)
> >                 return -EEXIST;
> >
> > -       /*
> > -        * Vswap entries have no physical backing - writeback would fai=
l
> > -        * and SIGBUS the caller. Bail before we waste a swap-cache fol=
io
> > -        * allocation.
> > -        */
> > -       if (si->flags & SWP_VSWAP) {
> > -               put_swap_device(si);
> > -               return -EINVAL;
> > -       }
> > -
> >         mpol =3D get_task_policy(current);
> >         folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), =
NULL, mpol,
> >                                        NO_INTERLEAVE_INDEX);
> > @@ -1028,40 +1019,78 @@ static int zswap_writeback_entry(struct zswap_e=
ntry *entry,
> >         /*
> >          * folio is locked, and the swapcache is now secured against
> >          * concurrent swapping to and from the slot, and concurrent
> > -        * swapoff so we can safely dereference the zswap tree here.
> > -        * Verify that the swap entry hasn't been invalidated and recyc=
led
> > -        * behind our backs, to avoid overwriting a new swap folio with
> > -        * old compressed data. Only when this is successful can the en=
try
> > -        * be dereferenced.
> > +        * swapoff so we can safely dereference the zswap tree (or vswa=
p
> > +        * vtable) here. Verify that the swap entry hasn't been
> > +        * invalidated and recycled behind our backs, to avoid overwrit=
ing
> > +        * a new swap folio with old compressed data. Only when this is
> > +        * successful can the entry be dereferenced.
> >          */
> > -       tree =3D swap_zswap_tree(swpentry);
> > -       if (entry !=3D xa_load(tree, offset)) {
> > -               ret =3D -ENOMEM;
> > -               goto out;
> > +       if (swap_is_vswap(si)) {
> > +               if (entry !=3D vswap_zswap_load(swpentry)) {
> > +                       ret =3D -ENOMEM;
> > +                       goto out;
> > +               }
> > +               /*
> > +                * Allocate physical backing BEFORE decompress - if it =
fails,
> > +                * no wasted work. folio_realloc_swap sets vtable to PH=
YS,
> > +                * overwriting ZSWAP - the old entry pointer is only he=
ld
> > +                * by the caller now.
> > +                */
> > +               phys =3D folio_realloc_swap(folio);
> > +               if (!phys.val) {
> > +                       ret =3D -ENOMEM;
> > +                       goto out;
> > +               }
> > +       } else {
> > +               tree =3D swap_zswap_tree(swpentry);
> > +               if (entry !=3D xa_load(tree, offset)) {
> > +                       ret =3D -ENOMEM;
> > +                       goto out;
> > +               }
>
> There's a lot of divergence in the code (in this patch and previous
> ones). Seems like a lot of it is to do xarray operations vs vswap
> operations. I wonder if we can abstract these into helpers, e.g.
> zswap_tree_store(), zswap_tree_load(), etc. Maybe the name is not the
> best, but you get the point :)

How about zswap_entry_load() and zswap_entry_store()? :)

>
> Here we can then do zswap_tree_load() for both code paths and only the
> folio_realloc_swap() needs to be different for vswap. We can do
> similar cleanups for the load/store paths as well.
>
> >         }
> >
> >         if (!zswap_decompress(entry, folio)) {
> >                 ret =3D -EIO;
> > +               /*
> > +                * For vswap: folio_realloc_swap already moved the entr=
y
> > +                * out of the vtable. Restore it via vswap_zswap_store =
so
> > +                * the entry stays tracked (and the just-allocated PHYS
> > +                * slot is freed). For non-vswap: entry is still in the
> > +                * zswap tree.
> > +                */
> > +               if (swap_is_vswap(si) && phys.val)
> > +                       vswap_zswap_store(swpentry, entry);
>
> Should this go in the cleanup path instead (i.e. in the 'out' label?).

Ah, maybe if (ret =3D=3D -EIO &&)...

>
> >                 goto out;
> >         }
> >
> > -       xa_erase(tree, offset);
> > +       if (!swap_is_vswap(si))
> > +               xa_erase(tree, offset);
>
> Maybe this can also be abstracted into a helper, but I wonder what the
> corresponding vswap operation would be. I think folio_realloc_swap()
> will have already "erased" the zswap entry from vswap. Maybe have a

Yup that's the right logic. We already change the backend to physical
swap slot here, so there's no real "erase".

> vswap helper that will only remove it if it's a zswap entry? We can
> probably do a lockless check first to make it cheap?
>
> It's probably silly to do this, and maybe there's a better way.
> Generally, I think the code would be easier to follow if we abstract
> away the xarray vs. vswap stuff into helpers (where it's reasonable).

I'm not entirely sure if its worth it either, yeah. Unlike load and
store, erase seems a bit asymmetric in the sense that we only need to
do it for non-vswap cases.

