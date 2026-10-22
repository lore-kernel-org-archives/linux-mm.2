Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47D9606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lPCSyEf0
Received: by kanga.kvack.org (Postfix)
	id D64316B08B5; Thu, 22 Oct 2026 02:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B776B08B6; Thu, 22 Oct 2026 02:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A0D6B08B7; Thu, 22 Oct 2026 02:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEE76B08B5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:53:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EE4E120771
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:53:13 +0000 (UTC)
X-FDA: 85349345466.14.6C57C71
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 14E2940007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:53:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lPCSyEf0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792651991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg3MYkiixfpOGWKpQ3X74Jm8FS7vqinp1afZZUlph/Y=;
	b=LB7uoQ4/6Uhstd/L+wxQH8iwrqHtRIQ+6zy3ZKENqU/cnsMBPbpmGoOXDakpeXa9bqknGU
	WyNgzWZuZD205RPt3QKfIWkcnTzIRNUbcbqI7CpBttGjzEBPnpTf8MI7pDKYLHZAhLOt9F
	q+4/ifCLu0H1BghstsWSWctmpgmQ75k=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lPCSyEf0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792651991;
	b=k9z10Hq0fJak44RJOYlW+rdET2makF9Wu6eUXI4wLp1Tvks8O+RSioiVxFcYIt1VITD722
	WpDu9SiyAMIUC0r7Aut2Z+fyINxrfEhnl/GV9/X3kVOgvdYLS8CpQ7kOc2ngXEycqK0NMH
	+OH7kRZEsmbNvV8zoDzWuFGX0Hq+50Y=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c450ab1483cso243687266b.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792651989; cv=none;
        d=google.com; s=arc-20260327;
        b=dEo9eq6FHg61FSutdLnFErfqCHOvG+zgxgMX/SaItLwOXhVnH5lx+kBtg3gBvP7dmf
         bnYXyf7GlHa7wZArWlKf5A4MPyizVhy+jAVAsyC+hcM8mh/2yM6IO3KItTn1vV4UD8Zb
         DIQqp+W9BBM0rx1TQ1UXvg7og2ZiyQ07gpW+b4Twt/Ng8LShruu17GA+Ia098Gbas3mm
         A8mEAIaCbxlzV1+4NheBdSj2GkVueVBKy2+QaWj4pbGJR5Ev66xam1Of0JIjK+51BBbv
         HqcAK+2bk0DNistQhLhIdCW7mitHthjf9o+DHTNAnaNple6VJXoZz7I9V917xjyaUBei
         +iIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rg3MYkiixfpOGWKpQ3X74Jm8FS7vqinp1afZZUlph/Y=;
        fh=9HTaXN4sYZp1Ts/LarecjJEjdOSjFQpzgT8596Q/jKA=;
        b=XOJnGzEN5vlIVb/YXDd2Cbu+ufBuLtkcaNb6E+mNjz+wlfiX9nhU36l67hFEsv0a7K
         LkUzmdMxC3FRzmpdPXjO5Ua5sJQ4N1TehzsV1U/OHsHWEJufeDG8o80zfQir1jSYOkhi
         6Faep8Fe266nhGuCcc9aNj1EuXmWvOAXNXnR8w6/s/xHRunhnRAKN3Ks8F4bX2XPtCFK
         dNqEKc61PmChAzan7ukJn0TKAmrDJPffPSnCJqjsKRQACo7VBwmtY1TlT4140r2dpybF
         lVfPs2+AYzS6bzrCJvdjW/8iBdlsFI4+YtOI7Fot1oXdwVydIyvBl1uEfEMyMTd64Uz7
         5oag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792651989; x=1793256789; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rg3MYkiixfpOGWKpQ3X74Jm8FS7vqinp1afZZUlph/Y=;
        b=lPCSyEf0TdIL4pPrYVhFP3tu/OlczLOHuIoL4UQa9iM/c/T3JvIjZ9IWHfBiJ/Tz1d
         JJmjOma1af6RnQUkjsIbFSRkSoVPGB9ZyjrXezuCTU7qlSQNo7waxsxVCIl+kWJFMr7y
         +Bm6p+0jsqM+2fw3Ju8lmx2iswmoJx2cxp64Oy9xOe2ssgwx4ltMuXDNWM4AZAOHkDr3
         ZLoIMrH5ptipueX/GMLbhZbXrOTseDr3MtIJgsr46jNE1bf58qWklvFTfmvZAUIQvehc
         EfQpnquBbkiKFBx7msoiWtu0mKJC3w9ygVh/8uyqkkLZnWwXf77g9G8Aw6KtJzhyuD9G
         +w9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792651989; x=1793256789;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rg3MYkiixfpOGWKpQ3X74Jm8FS7vqinp1afZZUlph/Y=;
        b=NM1nMYttURrIl+JvqF6LZpI8/dwLGDxSP+RUNy5UUHJM1L8ISa7wXvYh1ztkN2f+PJ
         2TnqSmwaOUnQLDwwKtggOEVRQpjXW0OJaVMm/Dr4gJP3BS/CkSo2tL9TwedzoHtpoXbg
         Em9amOBV3/7GYeyv7LOR5SK8kvojcIDWLRD4pWjkDNeuVWLfk2hSp21FJ4Wq8ynI0IKx
         6sTgF5k3JbEwRR3ZyUODqbXqMzzE0iRnjvYBWlPuZOTByI4T823hZ/jywvZS74Y3s11B
         0LXVP6hJfMmLFt88UpN/QnXZ4DCBnIjdD6rXjR+vdVamcr6/XNwZerNFy5gWC2rWhQkD
         XSSw==
X-Forwarded-Encrypted: i=1; AKwUvBwYbbiFBuwy5sCYPJougRM55V+i3Rs45zmhufnMdAd72YPSrKr/GeUp9HT56GCtUCRSMKm0SdpS6w==@kvack.org
X-Gm-Message-State: AFq9FYIe+ooLgOYqaTt43VATdsJoEqe8M3wN1Kw/Wgk8Dd4NipdBKBfx
	RcwJAJJiEakD9Yr2ZTObLeB6jtuAe8/dT4+FJkS/6xnGMhCyC+B/WBAofczFG+S7GeytDPWjMCv
	3roCPcQZSvVz2gPZMAilZGf11G+qBYNE=
X-Gm-Gg: AYBFou3RqVaks316n4NLJo+3Hx9okL3ir/SstU8YS3DdkCbl7zVI2TQnvJbFyTujWOV
	jMZc3ZmJJg1YSh0zRwuDWtP+4mYV8fXlGRwDUJEhWXuE1DmUqPYWI6GQUo+7Pfs/MvGHRSMlJWT
	UHQvapHndhAQ+MlFHeOXrY6s42djDToClngNlSd5heG8Rw8A+tzhu9q//M7Juk6w0JbOtf1/aM6
	2ziH0mnKaFvu5KIy+1py116u9Zbt+vMgOpbdntLRW4bMHHquFaZ9PwX9hVMX7osX0JsEzxmxuY/
	JGqFdxhvMeaofpA9zyNj6VIFdHu1iIT0kEWi99hF0d3WjtpgvdfK6CswS+ImErZiqL3u7GpxVIs
	iBPGjVQ3GKJvkYBnJNxrqpzlz6DkcUN26Gu1JMhiDd+STxl+MSduAv2Mvz6G20E45m90AU80=
X-Received: by 2002:a17:907:3e8a:b0:c37:8c7c:a840 with SMTP id
 a640c23a62f3a-c467966c0c2mr359451866b.18.1792651989383; Wed, 21 Oct 2026
 23:53:09 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <CAMgjq7AEg6XEUJPaM3mMBQAeS_KiDv8_za4w-R2WaZ=ZGenvuw@mail.gmail.com>
 <CAKEwX=O=PL3DEaEDe=F-=zhQ=VW3_UtcqesdX9fH_cr6orb2wQ@mail.gmail.com>
In-Reply-To: <CAKEwX=O=PL3DEaEDe=F-=zhQ=VW3_UtcqesdX9fH_cr6orb2wQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 22 Oct 2026 14:52:32 +0800
X-Gm-Features: AclHuK_1506PMfDGxQQ_jKcqLOauYM9YVlFaV9ZgB9uWuZJ7dc_z3c4TC8n9H3w
Message-ID: <CAMgjq7BSzYTbrzbA4vGqMbvegoHnDtJ0vA9PcwCet-m6Ow3ouA@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 14E2940007
X-Rspam-User: 
X-Stat-Signature: f156b16kyxp6hfyf6rq5rgo74fn7sfju
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792651990-558950
X-HE-Meta: U2FsdGVkX1/2tyx1WeRqE/4y6CXoHu7Ro8hAymeKC+sgVy120hdurqXIZUxRm2+CUyIe6RJRlqfp1ZUvj9iBKmS7aiHsrHhnFCSL0QghjrTAu2wYgp3E4IjBLQ5nQTz1LVUVFG3l3RS7F1esMwnWkmoSg1O0Hty0ru1EMwoseI0WA7cZmsOmjVzccr74A8AdRvAmYzg3zrGGIjqzYbG4aCC408rcr2TH94DvIXPvJWiFPwptnnGMNrhZ1VW2J+luDBcPpURcTmKvA9z3CL1Pf7pG23I9M/6sLWXYrFnJtFFRldgafJmDMVf16Smt/UXRGwTnRua9kyg8IKioDsoCysVebsndE4DtDG+wTf4yiYAgdziQDc6Jft9yZW7jJQwzdtbHtkhqpODiImP/+XR5cL65dioej8oFfRXYr/8ATnCduCmVMt6CpSgs1vNDv//a6D6G3enfpqO1aq5APL4IOs8qvaXfxM6uREt9YBxIJQnQQ/0emTOP30GtOqQL1VHlU9YxuA4MS4RT/ehE+xZD0zPt4Wbgm3KA5AS4VSuifhYOgy9cy11HUBDBWNJU+Qs0i1TC8l5Xa80Yr0OtOJsbmxDwIEgtboXT8/MhbfUfQ/PxHhaC+jZV0HTvXOhWnvZ8L8txfXS4UVIUdrv6B3g2J9iiLFgJP9Th2NF/chP3wSX6FaA7ETqo3Qg1YCkABFIVyd+eefPARmmKSl4lmiQcruPDz6INLHBXGZenARKcp7L3JyCbBtHowMeufcKH9uMGRxttD4GxYycGGB2mT9/irF4PC6ZsG/A+DKhxGgleBnjwVhz5P1nXqYcHMvUllpV2bbfiIBEqoSyX7ggUqokMO+8RoQdbKiPzXStAFJNYCUHPdVcdr06Ksp3perOtWtZCHk8293lGw71tDztAISrWXHhkeTXWNhw3YekgfRi+9XeGRYYOL3VWI7s+ZMtxEUh1xoWQ6bqMgQe4hcirjvb
 7nCLBNBx
 n19dpQyUejma1x1Vw92f4+pzlyTA5UfXZJ0ApjnvYUck+KkEDB9egTBvMLeYnhx25sW7CjFTW02YAxu7sMZ+n1vxRAuKOdpNY3VkG2MSDnpIA98ri0dB79GlNw/gPCWH2qoOYRAoCFEDRDqxyRuPnj1fp9+YujvqoGDgdtVApU8MMSpqCG8lgQdQF6z1HqkJ7l6c/z8NHpnGBKv84Vq3UQuUPXBmzZ6O2P7H3e8fPI+sjhvbRVZC+Prrpl9mH8d2Xu54f33cY4d+fl4vpLramugQD+nSuxnlOGWzWir80zTEPyY4XXOgG2gmK1U+6dw2e5HtS3f10vmDClkW9xeEm2yauh61BruDEYRynjp2a1RhKPe0n8RuKUwjs+PMXWzZV5i3fCKPo3aqt4oGFoQQOSggT9Go2+TBkGjhR33tmGSg5ujU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nhat Pham <nphamcs@gmail.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8821=E6=97=A5=
=E5=91=A8=E4=B8=89 04:19=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Oct 20, 2026 at 10:58=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Tue, Oct 20, 2026 at 1:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > swap_cluster_populate() can publish a cluster's table with the cluste=
r
> > > lock dropped. A cached allocator can use and empty it before the
> > > populating allocator reacquires the lock. The resumed scan can then
> > > dereference a NULL table.
> > >
> > > For example, CPU1 can retain a cached cluster offset on an SSD with
> > > per-page discard disabled:
> > >
> > >     CPU0                          CPU1
> > >     ----                          ----
> > >     swap_cluster_populate()
> > >       swap_cluster_alloc_table() fails
> > >       spin_unlock(&ci->lock)
> > >       local_unlock(&percpu_swap_cluster.lock)
> > >       swap_cluster_alloc_table()
> > >         rcu_assign_pointer(ci->table, table)
> >
> > Nice catch!
> >
> > I think the real problem is that it turns out calling
> > swap_cluster_alloc_table() without holding ci lock is bad idea... I
> > think this patch still leaves some other call site too?
>
> Do we have another callsite? There's a callsite in setup code, but I
> assume that's safe...?
>
> But at this point, who knows any more. The caching only stores a
> swapfile struct, and an offset. I wonder if there is a potential race
> between swapoff-then-re-swapon and cached allocation? That'd be pretty
> wild.
>
>
> >
> > We may instead add a "bool locked" to swap_cluster_alloc_table, and
> > let it lock the ci first before it does any assign (not the alloc) if
> > the allocation context is not locked. That is, keep the
> > sleep-allocated tables private until swap_cluster_populate()
> > reacquires local/global/ci, then install them under ci->lock,
> > something like pre-cdd77f84d966, always assign it atomically.
>
> Hmm so a bitlock?
>
> Lemme think about it a bit.

Ah, no, not that complex, just something like:

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -449,9 +449,13 @@ static void swap_cluster_free_table(struct
swap_cluster_info *ci)
        swap_cluster_free_count_table(table);
 }

-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gf=
p)
+static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gf=
p,
+               bool locked)
 {
        struct swap_table *table =3D NULL;
+       struct swap_memcg_table *memcg_table =3D NULL;
+       unsigned long *zeromap =3D NULL;
+
        struct folio *folio;

        /* The cluster must be empty and not on any list during allocation.=
 */
@@ -472,8 +476,8 @@ static int swap_cluster_alloc_table(struct
swap_cluster_info *ci, gfp_t gfp)
 #ifdef CONFIG_MEMCG
        if (!mem_cgroup_disabled()) {
                VM_WARN_ON_ONCE(ci->memcg_table);
-               ci->memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
-               if (!ci->memcg_table) {
+               memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
+               if (!memcg_table) {
                        swap_cluster_free_count_table(table);
                        return -ENOMEM;
                }
@@ -484,8 +488,8 @@ static int swap_cluster_alloc_table(struct
swap_cluster_info *ci, gfp_t gfp)
        VM_WARN_ON_ONCE(ci->zero_bitmap);
        ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
        if (!ci->zero_bitmap) {
-               swap_cluster_free_table(ci);
                swap_cluster_free_count_table(table);
+               kfree(memcg_table);
                return -ENOMEM;
        }
 #endif
@@ -494,6 +498,20 @@ static int swap_cluster_alloc_table(struct
swap_cluster_info *ci, gfp_t gfp)
         * Make tables visible to cluster_is_usable() after everything is
         * ready.
         */
+       if (!locked) {
+               / * Lock it here before assign, not after the asssign
and return */
...

This should fix all potential issues I think?

