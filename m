Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB241C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD31F6B00B3; Tue,  4 Aug 2026 00:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B843E6B00B5; Tue,  4 Aug 2026 00:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73886B00B6; Tue,  4 Aug 2026 00:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74E476B00B3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:17:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 060711C1491
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:17:15 +0000 (UTC)
X-FDA: 85062277230.20.771770A
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F4678000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:17:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NPizKSRG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785817033;
	b=PhiJjya72+ffJQX7xiil6whYJ2V6qK1OsTUrnLY05R44k/3G0EEhNuR3QJd4kAojlM1yM/
	3iwxk8X6lhNsb6qXdtZtaf7xk5+4eDcFBvMy3nRty1jn5O64m/6Drji5Ox2rHwJPNCOh3N
	pygaqJZIhAMLFESVSXnc2VfZsVhUtNE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NPizKSRG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElBuOqrRWACqTA1t8hoKAgzuqsH/zxl5SbufWQRpAQw=;
	b=baopRENjfhVJkM8Ox4Hs5T/js1+JMxVaB/YuVi4PfNq6MBLDSQn6nfUwHElrnpD3dA4iIv
	QePXEG5uVhi+CxhlcLp3xdCwbjiArHzmX3Idf9tYvr5LT7/EjfaWfJx6wpKun6iqI8Gf7O
	oozQN67YUuTbYDpm1pkmw5TvSycSXYc=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ff017d420so9026897b3.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785817032; cv=none;
        d=google.com; s=arc-20260327;
        b=FzXN3QUktNgkl2ktzlG0TqANoDqKaGYFD0wGou0/4MsmhN+pR+gQwvAekH+nN89Yka
         Ve4msGNC7wLdulh71F4VSDGLlTzWXsSteaaYGitLzgPfVjg3xIN6RLrKyVO3fV34KOHq
         xm8/TxX5q//NViOuSX++lvCGqnIjYW0V20Eq/fbLSlsf+MzmFpHm62qQmYggzHS7gaZ3
         afVB3Qb2icMocBZanlVO6kzOi1NGfB06bi/IQCqPBIQZatrLldSJ0AiUyzrqrVScOSDs
         nM+mwoyZ6/duYX+m+uAM8/q+8+HEEDKmQi5b0uOGDzfZqGWV0GcCjM5tPNPQKZNf52dv
         gLyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ElBuOqrRWACqTA1t8hoKAgzuqsH/zxl5SbufWQRpAQw=;
        fh=cx7MnMl/E6nOa9kUrACUGATxs6QAkYf8rye14/ROA/k=;
        b=RJ4+hdzPeK7FaljeWgRE7mwpZ6LA8AGm3IkEM17OaaX3tVxlGaPqPYeY9yiyghoECt
         GVKs125dsaOZaKUwbO5JYkNNhrZMiKgtRWdw4uKt1TtdqAZXvbd4b4ahJqZNZ86nVevi
         tWZav21lzl7WWaivLIWDjH8O8DkGP9hA8TbS/B5yaRb6WdAZ7zXTE3XHfkucq2/GY8Wr
         orGlgxXRSIsCWOdMjNOtfZaBoEX66iJlJqAD22IXQeFNPAzSLVa+RABeh2EkT205fFpC
         uUfgvGIKeEka0KigSpRS8yf2f2kQPh90SPXeOnrdfuGfuEQnXdqSAAJfyEmjDSYtCgrB
         lOoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785817032; x=1786421832; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ElBuOqrRWACqTA1t8hoKAgzuqsH/zxl5SbufWQRpAQw=;
        b=NPizKSRGbEzVAk8Pzo2+pFxcRt7hwvYsWeH/3NKwbcXvMliGrSpDc/MnQ2ptDMB1tk
         YoH+A5t03P3n1u9l/0Xk5w7OiZGvjSkkkcDkbQl7K5hZ6IqLKv+K7RiFTfX9b0746InU
         D4/K8lud54hWiViSLAEiH9RqKh0eEdQLcDespsrx3BNlW7PSEVMHCzaPw7Mw7Fp5lyd0
         IlHMWC7rSjn+rCoYOu6v6oUUE4pzrGVVLQhsRwDL+ul/WXNOd/dDtiVVs8EkxImaiG43
         Udo0B2DKhrBFsKZcItqytTVMCi2fQi/sbbjVwLPfH/blYtnwGjZTVFkJHPw3eXj4tRIX
         GUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817032; x=1786421832;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ElBuOqrRWACqTA1t8hoKAgzuqsH/zxl5SbufWQRpAQw=;
        b=LZCoP/3yUbbewYDmo+r6kL+ePyruw8FH5i5KZaAoAR70IGKUz/irAgbWqxDE1nwJFW
         qpSuLs4gVOQKLRd7byg5kr1ie/pFCXEV+UCw1iAdbJtVESO/2G2uToy7uBfM0529M0Rl
         ZdfFP/IfCq6Ki7YXvHOy1ll/HQkdEJwGIFn0l84Sb5d6r8Cx2Flh2aMTvolc8p2mkW4X
         yEX4lboJocCiuDxCeEuczBq/o+Lf7KZ0r5QonUnbdwftfFDax6PQBSGF/qvvOl0Gz0I/
         nAKN/E1MNnQOvdJMr/omTrNkAsIrabxdUHzR2hT5oqxFwo+E3uXVWPN+nEqTVxJAmkYx
         BFpA==
X-Forwarded-Encrypted: i=1; AHgh+Rq71oKrjaQykj9T8E+vKoo+YwsOXl1B9u2IfXecIS7/2gLmNgUaxz3zFvfcR0cjWFJ9Yjl3U0+bcA==@kvack.org
X-Gm-Message-State: AOJu0YwuF/IvIM1B8JzY1gcZRKprqwgz+pAuhJPvBD+4YinrWMv26e2Z
	ya6pAHTKwCBN4bjAkwD5KBbzgdB0q/SdKIdLLP1WwWRUAKvPgcR1UfvxEADJNrXxnGELjqCnTBG
	xwJGYp5mvbKS8uUTJGFFUyzLsH56mVVY=
X-Gm-Gg: AR+sD1384/Shq2yLvY3E5N0Xu25tDtXwIe2HRvte9NcBwy6ZRvoVLhClEMNiO0Umzqn
	0PJ1bERxflj77S7dP6x1FBpB2vG//yqKTtmIwlXtCxhgws8craZb2cjbBLVLgx6GDiFiXifdUkr
	OjJ9wqbV61DRGKYXz5K27pOVe6gyoeqAZzkcEm/0GnTUESF8NbuARePuWxkUYKrP+lIFg+fQMHK
	td3jpJaAma41+5QMabWq6izNFJruTO+sA5zM2ols+XLzw4K072xEBuALa97y+OV6iLg8eGi5wCV
	/n+6up/lUP5GfGGlpi4vDWFp6M6hFwNLQZnrCZ+s3pNJs/rKEMoi
X-Received: by 2002:a05:690c:3412:b0:81e:8498:b970 with SMTP id
 00721157ae682-820097e4925mr17523077b3.0.1785817032211; Mon, 03 Aug 2026
 21:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260803134822.2568766-1-ekffu200098@gmail.com> <DKFRUZVRDMIZ.Q5GDFVAD25Q5@nvidia.com>
In-Reply-To: <DKFRUZVRDMIZ.Q5GDFVAD25Q5@nvidia.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 4 Aug 2026 13:17:01 +0900
X-Gm-Features: AUfX_mzAjmyLBEIjY5JBKIIuS85kMt2R1WvUznx3WPEYTI_gZn6RQr6GCVbq3-0
Message-ID: <CABFDxMGbdkJwv-jPnfVww1Z+wg=+1x6sT5bH1dvxY3N==gJhSQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_ext: remove pgdat_page_ext_init()
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F4678000A
X-Stat-Signature: c5foqxj9paoa8ha35xs9egtpkyj6ry7j
X-Rspam-User: 
X-HE-Tag: 1785817032-326941
X-HE-Meta: U2FsdGVkX19TfpudNxe3K05gH1QqDYOw3dKgkYv6p623ubqleDD2V+SQL21uwwDAWf1AaPe2OryfIYYJJ1+vPg9WrD7TBBTQz0bwg9D6XPQICzI/zJOqBmZ3srfWQvjMRyVuSLfFigRpUiGxSMKnyAY6k2+qRBzA9F9bAMfbWwaPbAkK0v9OsrA07Usf5xF/COeT1UB2ZGtSO2AxFzSfbTw2KRNzcp86dXXytcRR4GEILQr0R3xQHmiBVIFeBkTob20d4PGMw0P4Mn0Dl+18ljAXzCgkz9PDfCqbZXOrqhJKbkjSYntWAXw1972hjC9KG7N7BxIK+xvJ/gdRLR8Y0qp6FimH6NZG7j2kSccvCipXFzoha9er7fG/EnZ/aPv/SwcARVIR9F7ALN2z1vW6pIkhyCFsVHNu63cSAvSuPA2XC5mHA/xkMFeb+U23drOvyyDXnCrTz3JzeD8pE2diz2svpmGnms7U6dRfEOTDFQHeHS0CLMgy6UZbIXzoBc4rp1hLfkLX5J3NdPEeASbUI5CMALOG1bOMd951Go1nAVzZF+/f5aswbnc4N6zrI/lxFfeRzfJnnDdw6tq6ixK49iumF3Eo8jxi4MlH74VIG2m6HGPKzUFaYr8J9gtWE/PN5B06ZCPXxcPgyhbY6beluGLTdeys2Ea+pFia2ur9m95XwBSMjZuTe/s8wtqiwEmu1Qii3K0rKUhQAjq2r+9QDm0DV4ApFqcboTNT1Db1MPo3E6g8DqOebWZjkoA9TeRxgeY2675838IY9FSMY2yZywJRTq6kfO+zJDz+MhbXwuedmgt1uzdIbSnqSP7es2Ruajq0jL1C7DQzYoBxnQgzRba7U1YRF+xRaHess4D7z8M6C9cqDiOg+wXgsr/QHdaayimW61iSMLeYEwAri0ls6zVy6JXVv3yXhtrjy8Bi0t+PIQ92/ni5AJDkzZG6tAh0v+xXLtL5M0fh3s3q7nQ
 pgZqDVIB
 uukgnAAmvQAmvFimwFr5PtunREv+9NSfYOjvApDdsmj+QNTk1/4dhDqh0J5nS5PuU1qcUi79ZZfDlOTsXOTBHKLKUxz/5Op4F4Fy2zn356Ookjmf5k+idBIGCox38UusB2ZnoV+rmle4Mc7526hmjDC5IbaIDzaqV3w3a3B5yb5wPXeFGo0nblQA0pdDPgZWN5cJi8tWpp1tUTJ/tALYpZ5H2INvivDNUTDJwO+4l4fY8qK1UeYOCFTSq3a060nrHwqgsKCEPULSszJZ1304t7UMXOSo9DtZjOC7kiEf9hJFiRhpYc3fDjMYl9uNH6SSBFTKBV3+R1KMDQny+dYByaMEQahJlJd49LTNdunByVsWe0R58aI+lTiQh4QzC5GVkp6yRGbjBh2Jlen1SlDSw0H/b6iIKhJVSHupdgUCb1uEImqhF8kfm86PTkg4DHt8ca4Zo8ys7I9/pKC8hARs1nG/+crvRcuj4NdVh8jgYM50k/60ccT5lHqzZkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Aug 4, 2026 at 10:35=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Mon Aug 3, 2026 at 9:48 AM EDT, Sang-Heon Jeon wrote:
> > pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
> > FLATMEM. FLATMEM depends on !NUMA on every architecture, so the
>
> Should we add "depends on !NUMA" to FLATMEM and FLATMEM_MANUAL to
> prevent FLATMEM + NUMA being possible? Otherwise, FLATMEM + NUMA can
> have issues with pgdat_page_ext_init() being removed. I understand that
> no arch supports FLATMEM + NUMA.

Indeed. Existing NUMA code depends on SPARSEMEM-only macro, So FLATMEM
+ NUMA is not buildable. Making the constraint explicit sounds good to
me. I will address it in v2.

> > pgdat is always the zero-initialized contig_page_data and the store
> > has no effect.
> >
> > So remove the call site, the unused function and its declaration.
> >
> > No functional change.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  include/linux/page_ext.h | 5 -----
> >  mm/mm_init.c             | 1 -
> >  mm/page_ext.c            | 9 ---------
> >  3 files changed, 15 deletions(-)
> >
> > diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> > index f23d4b218da0..79c53ec45dfa 100644
> > --- a/include/linux/page_ext.h
> > +++ b/include/linux/page_ext.h
> > @@ -55,7 +55,6 @@ struct page_ext {
> >
> >  extern bool early_page_ext;
> >  extern unsigned long page_ext_size;
> > -extern void pgdat_page_ext_init(struct pglist_data *pgdat);
> >
> >  static inline bool early_page_ext_enabled(void)
> >  {
> > @@ -202,10 +201,6 @@ static inline bool early_page_ext_enabled(void)
> >       return false;
> >  }
> >
> > -static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
> > -{
> > -}
> > -
> >  static inline void page_ext_init(void)
> >  {
> >  }
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 711f821f7b3c..e9c4204b73ad 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_internals(struct=
 pglist_data *pgdat)
> >       for (i =3D 0; i < NR_VMSCAN_THROTTLE; i++)
> >               init_waitqueue_head(&pgdat->reclaim_wait[i]);
> >
> > -     pgdat_page_ext_init(pgdat);
> >       lruvec_init(&pgdat->__lruvec);
> >  }
> >
> > diff --git a/mm/page_ext.c b/mm/page_ext.c
> > index e2e92bd27ebd..b679a8c1f7d7 100644
> > --- a/mm/page_ext.c
> > +++ b/mm/page_ext.c
> > @@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(void)
> >       invoke_init_callbacks();
> >  }
> >
> > -void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
> > -{
> > -     pgdat->node_page_ext =3D NULL;
> > -}
> > -
> >  static struct page_ext *lookup_page_ext(const struct page *page)
> >  {
> >       unsigned long pfn =3D page_to_pfn(page);
> > @@ -494,10 +489,6 @@ void __init page_ext_init(void)
> >       panic("Out of memory");
> >  }
> >
> > -void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
> > -{
> > -}
> > -
> >  #endif
> >
> >  /**
>
>
>
>
> --
> Best Regards,
> Yan, Zi
>

Best Regards,
Sang-Heon Jeon

