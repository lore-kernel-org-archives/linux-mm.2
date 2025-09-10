Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E1ACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A238E0005; Tue,  9 Sep 2025 22:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FCB8E0002; Tue,  9 Sep 2025 22:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4561D8E0005; Tue,  9 Sep 2025 22:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EEB58E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:31:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B640786C86
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:31:15 +0000 (UTC)
X-FDA: 83871763710.16.A057560
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id E4F1940002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:31:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AdQq79Yt;
	spf=pass (imf04.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757471473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGYOV2JHkr+pmYrSJQK9SOPoU4vgjNE883gSiydCMeY=;
	b=u80Sms1ahDPj0LvxQ4AUwzHKSW8Rd6BDjvxQMNIjjloHjdybHEyTnA1GLtsRmZOaZEq/Hk
	o/lVW4Vq3OK+0HCDbw2oeLaaPVX1j/QKSJLEquAMJ/Ly4uR75T6ts0jTXrVzaQSK1osx8J
	j6dCwvX65gDgmI8HE6i3Akw/T02WU6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757471473; a=rsa-sha256;
	cv=none;
	b=3EH6+F5AOWUU+Y8Tw95p8MWZK5zgq2/U9w9GQR7YyibK53DW/TIi690ApYGpIuACIQ+TEy
	io30B02uLd5DH45JIoR97OLTi72oLlNvPuxDkmX0ZPAMXREeotD60TDzssoQLZyL4RUJyY
	r2ixnOSffe9bwB2N2nW26i+PfhfuU6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AdQq79Yt;
	spf=pass (imf04.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d603a9cfaso52722167b3.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757471473; x=1758076273; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gGYOV2JHkr+pmYrSJQK9SOPoU4vgjNE883gSiydCMeY=;
        b=AdQq79YtEkFb4VQCL6uFoclFyefItF7JCL5G4v0UUk/dA6vKfJIiPuyhsJFD23Yhwr
         qaCOdgFea2/nPLix/RVCBgP92HSmDE0lddaTqhZDaWP/ikgUzcyDwvCyLP0SYUi+Drwy
         vL5Lgj+gqXVNISBqlnb77G8Fn0zbv9pyJu7G9RqimgzjheWFM/jwdraRvMrblt12Yyms
         ibDdQd7nWmH3u8yQftGSa8z9N3tZW7ksXGMAvyiCoz5XqwQIG/1+6vJKtZoui6h5UiFi
         Lj6lrRyNyB6JupUOqnA+stbyrpvFiEKtO+NPBkuuax7t5n9WcFaoF8lCoiAs3PwzAiFr
         YYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757471473; x=1758076273;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGYOV2JHkr+pmYrSJQK9SOPoU4vgjNE883gSiydCMeY=;
        b=AG6ga39r4D0EBfpJX6IN05OQ/dW5Yn8ELvFnTQ3UPSqwN9fHq4ZB1NxEjIlRPCp3Fj
         QlG6K7T9qWYDLcYqzPnoVtAXzU4wT94P0z5PSnlQPDGdRn3B+Z+tPiTm5OuooQ6pxMSM
         2sMShikGtZm03RSaPtGxgNIDPNZ0E177cE/pxOJvuqVl8UnF9vsqki7ZlXPOeH5RBJxF
         KdQ4M45kED9Z6fcmDkjbMPeBN4ag6FifQHgu0b8Ax+ndqOhT+DMsPjIHb2IycUB/HTkH
         nnV6rndYeKqMeBRwNP0FR+/+9tXBeFE+f+Fd4TSPJQIP+RFapvhpXXS9A9sTE3pjpJnb
         8X1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWswkyB/hePTeqX4N+WQROY/fVdFvOj+M2AmdT6wGR+vqNB+n0P4PXjzje98XIwqZH26Ux+WS5bAQ==@kvack.org
X-Gm-Message-State: AOJu0YxMi2b1mN5Dh5Jd+RugpgpM+yzj/DI/F/GK+FDmFwHUIF0LFURG
	JVghVVjN855zHVU54C1TkUkHCXWA1eGgpG8onixGdSRumi4fZ1AGVeAlM+fXWF9WybD/Hd4Crou
	vMkXv0jargBJE0RDaGhTpBJ1idLA2XgU=
X-Gm-Gg: ASbGncuYdx2YjcQ48sHij0CotsH5/iGo920wnICSTzjIEoIO+48zVQLGcdoUHZxTIJe
	qK8j9/9mq8PoIc/B4QAz94jPd3zRCf/ItKnQdu3wkb2qVtKYU9/96ccx2Qpe1bZFGjWt+Wma1cZ
	xxhk1Z6ttDrAjgRY2034vY84WyV3Je6bKBNmUV9MXEICZ87trFdyLoh2jTR647cJlHrt4egINmp
	6xiZ6h5zB58KjtUx/w=
X-Google-Smtp-Source: AGHT+IGkuYKbHclUoNcOzVWw7oQ2X7bUKO4dFGcNmQ9KJ9GMuUtVZDutEeAw8KLoj4aY+JeJ03Z9Ze8oC7BtIPAvMTU=
X-Received: by 2002:a05:690c:9689:b0:720:5db:1220 with SMTP id
 00721157ae682-727f27de65cmr110345907b3.8.1757471472702; Tue, 09 Sep 2025
 19:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250910005957.54108-1-rgbi3307@gmail.com> <aMDW1urp03myzZFi@hyeyoo>
In-Reply-To: <aMDW1urp03myzZFi@hyeyoo>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 10 Sep 2025 11:31:01 +0900
X-Gm-Features: AS18NWDwwoRllFR4k3dRG-FUT86xf3SeEZv7mFkYHOI7mhydYUgFVRvyPwSwbbU
Message-ID: <CAHOvCC695c3fBphYvVz0Gk3H2hR9O2GaQLPvOVSZbUyv5C5rwg@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: Removing unnecessary variable accesses in the get_freelist()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, 
	iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	roman.gushchin@linux.dev, 42.hyeyoo@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rgbi3307@naver.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4F1940002
X-Stat-Signature: zkiyyk5p6qakjkwqiiwb3ihea86ex9cj
X-Rspam-User: 
X-HE-Tag: 1757471473-425512
X-HE-Meta: U2FsdGVkX1/Wwiqoxv6mAi1/6Up6IhW++56IgAeTkRoD/ALdZxifgcHYR/fhOVmT20pb5b3TDBof/Bh1UpnmReVsbFf5bFBl/uDCgRv42XSKrlksH3hsDWt3l7+XrB2wjDXkc04TcDsnWRLftyWGQdAOVuAbyyLKJkPTTSHdE4S2cJA9fZyGYxzIVKZTETceX69/zwgh9taYSK0P+aCdMURMJeWme1MFw3N7pk+z4uj2INo/xc93W0Ev2n6qYyZR+nB/pcBbST0ikmJY7sG3k1U4v8Cepq9RL553gTLX5NG+YvlDVJt3qp1VyQ0GpFsKE3UtdYIZ2+bXMBiYvF6z3Bv+vCaBt3uWvDzBgSKQ6LcfYkwXjTzIWyXHzdi9gbOLVs2DvTt1MUJWydZXThXvH3VwuL0k/MVnmgpt7I7oubzM2ZAZSRuFLcwvnHR7vTaYnIsM2pO82zkFKL6l93GEc4egigJVd8kq8nSL3Z9eDt5qpE6q/VpPOyhG9UeRY47zCJL43Yckp3VlVeJhCHlG84uFKWGLHow0SOyNN5ztWa4wUcBVZOYJ/FQf8+H0SMb2KFK8wDEgl4Dc2nMQwd8TQfh9BtawoK5jqNhvNpaHpRNZm2lbU+Ws2WqgG2hnN8qlpknqxJQO9cWws1+zAB/NErIyl5sAtM6iPROdIKuEOAB0cbERifCPSqd5NU60oqDZsWxHANbe1EHRyHXMbZbE96htSr/HVdZIB21SYyGSjKSTa22Ckg2xsON6deYgaWzLA24zte5b5sONP5msAEABkZkDGd191TLFnn5/pavMn5U7QCXckUldfOC81Qc86+HpAuw0tEmD2ck77gGwlJDL37NVHVfh5FVm79Ie2woWyM9kn15ZTSqMg/LcHPVYno5vXHPKhNUSTD+vJu/BE8jsBF1tatXXVUtTL4Qe6oUzLMkouDa5Jk/GVm7xGMocaT9Cxx7S2oPgzxCg3jogj6u
 +gdWKS42
 1EpF/xEzyFq4PSAVmC4C1PeoU6vXUI7z/oZrDHkuTNfnJoahHvRY7IkdtfQbPM+/YQtyK+UldRvolmdzpAI9EIajDeapisYEo6XgxYU4PTfYspHeMPstxa5/66mn6g5mfma64c2l+bJP0uoXWpmNT8UBSi+qVq5x7OKpln92ASI66++QDSm3I6uXK2BlTYDx7/Rp15CY/cHnMrQd0+qHDMPoNl0q1yi59AcTAuNaf67BWRWFRa2wbIuwQLmJWIzR3xNDp4Q28Yc8EXmLnqV3CbHMPDdUyftqeqzi5DCkie3aLtfXU8Smr2CAuf8xzc26vi5y3WWrLnR5p4BKrm/UtDvveD+yJrQ5gQYC0EHLp4y+T+YdaYU0bfS0G5WFoTPaSXlX8rOYEQMmGA5xPq93DWfSRRwgo1fdaZYHyvoclTNuoht92ru0+nQw4DBoGSgHim0MFlhVI79aQdYXiladV/MxwwPobhvruSP2XOX4Joj6sf9YOIOW+lTw74YqrcejFeKXcy5GEmwY3d7E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Harry Hyeonggon Yoo,

Thank you for your kind and detailed reply.

I hadn't thought of the union data type.

Since the counters, inuse, and frozen members are unioned within the
slab structure,
there is the problem that the above values are not applied to
__slab_update_freelist() and try_cmpxchg_freelist() if the existing
code is not followed.

I canceled my patch request.
I apologized for my inconvenience.

On Wed, 10 Sept 2025 at 10:39, Harry Yoo <harry.yoo@oracle.com> wrote:
>
> Hi Jaejoon,
>
> I updated my email from 42.hyeyoo@gmail.com to harry.yoo@oracle.com
> a while ago. Please check up-to-date MAINTAINERS file when sending a patch.
>
> On Wed, Sep 10, 2025 at 09:59:56AM +0900, JaeJoon Jung wrote:
> > It pass a NULL pointer to the freelist_new variable
> > in the __slab_update_freelist() function so that it don't have to re-fetch
> > the variable values inside the while loop.
>
> No, it needs to re-fetch values when cmpxchg fails.
> Otherwise it would fall into an infinite loop, no?
>
> at a high level overview, cmpxchg works like this (atomically, of course):
>
> retry:
>     old = var;
>     // modify some bits in 'old' and store it to 'new'
>     new = old + something;
>     if (var == old) { // compare
>          var = new; // exchange if the value is expected
>     } else {
>         // if var != old, someone else updated the variable. retry
>         goto retry;
>     }
>
> and this retry will certainly fail if you don't you re-fetch the value,
> modify it, and try cmpxchg again. The 'old' value fetched before failing
> cmpxchg will not match anymore because other CPUs already updated that
> variable.
>
> > Removing unnecessary variable accesses as shown below
> > will reduce the code size of the get_freelist() function and make it faster.
> >
> > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > ---
> >  mm/slub.c | 21 ++++-----------------
> >  1 file changed, 4 insertions(+), 17 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index d257141896c9..2e305a17a9d7 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3654,27 +3654,14 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
> >   */
> >  static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
> >  {
> > -     struct slab new;
> > -     unsigned long counters;
> > -     void *freelist;
> > -
> >       lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
> >
> > -     do {
> > -             freelist = slab->freelist;
> > -             counters = slab->counters;
> > -
> > -             new.counters = counters;
> > -
> > -             new.inuse = slab->objects;
> > -             new.frozen = freelist != NULL;
>
> ...and the frozen and inuse bits are part of counters field,
> so they are not updated anymore?
>
> > -
> > -     } while (!__slab_update_freelist(s, slab,
> > -             freelist, counters,
> > -             NULL, new.counters,
> > +     while (!__slab_update_freelist(s, slab,
> > +             slab->freelist, slab->counters,
> > +             NULL, slab->counters,
> >               "get_freelist"));
> >
> > -     return freelist;
> > +     return slab->freelist;
> >  }
> >
> >  /*
> > --
> > 2.43.0
>
> --
> Cheers,
> Harry / Hyeonggon

