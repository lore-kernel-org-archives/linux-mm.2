Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBF3C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D426B0088; Thu,  3 Sep 2026 08:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55016B008A; Thu,  3 Sep 2026 08:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43CD6B008C; Thu,  3 Sep 2026 08:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6236B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:59:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BC8040525
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:59:41 +0000 (UTC)
X-FDA: 85172457762.09.6E1F38A
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3C4062000D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:59:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGq7pZyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmAdg8/mefR05LTJz5ypL2PwZdELomAbn6h2iC+gq4s=;
	b=2gafvyxFOS69CwhtPfmSsCMR1GqE8uOpT95+wtafMXVpL74/ya96f/akWdcEMIM+6sN2Sv
	SOJg0jD8lp3JVKXa0mGnM8IZQAng4BAZOjrRd97fOHwK78xriN0tpd747Qo44B4uhdoiSX
	lbmQYOyoOMNXfm1hyDkhacTZZFc0Xmg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGq7pZyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788440379;
	b=uFqIKr/KI8uXELi+kN6/ttestjTV3kWMYeSu05SUTXuYX6siefxnm22rru1ShoSkY1V/Jj
	O27KCx10k5HxwF1yZOucSRF+H2asdBDoYQrTmDDs6qdOwj3tDnpG5rZJWO0W27QKXuvuNG
	B2ZY+IMmAYbnqehv5jtZHJ0xUP5/T9E=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b01910b499so1035093e87.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788440377; cv=none;
        d=google.com; s=arc-20260327;
        b=G9waW1g3rpVcHciEPb73W9BKIaQPGVrCN5Wxd6wIKHui9I/a7+G9jv9q80ONzYXj6W
         RgDMl+KnHqzvCTd8jpLgKosopH5ZZmdLPWsuOo4qNYRKlqv7gCoNCSkRsPS8WhLFnB57
         YD9iv/l71dBpD0WdyBsMA8V8HRc0uQK0QpZU6azB6D6AAvb82+JMIhB2dnqGzKR6Dxn/
         I2PGgMnwNUHJXt1908PtWMfMYi7NwF96HmSD46pG2X9YhP2ti//mw3EXArbrnqVPUzlt
         FAAa597m+zXV8sGdc0WkPO/n9PQuZhJTKldVX+/Zc7vQgHVAyQ/WVrRqoJXwITaaiMAe
         at0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BmAdg8/mefR05LTJz5ypL2PwZdELomAbn6h2iC+gq4s=;
        fh=LcwF81iihNGTcmnYFhVGV8GRUSn7TXUT3bwOQpdXsfc=;
        b=CQmB9mO5Ta+1kwDpSax+zPRJqH7ngkzZYhHgm5J0H0LNeYsXlqvchaBRlafHcNj9pq
         NabOcKtLcz3x7XDpphYxKaGZkgREkSAXnMfeuTHnKxkN7N4j2BZU8UgTb2h3z/B6nNiU
         3JC0Ok9aLAz7/1tvEwoJ+WcyIP/C0XA62wTNk5YlJIBhkj/K4v6wxdJhXvtby2iIU5eR
         itxnvlxadvxRxVwePM7VJIinOuqpiDIThcGqV4o4SP6pDTVqtqx8Y/zZL4ctftTFNvqQ
         wQU3Z3h9vKByk+mVTXGC7kAtW1iMZX1XF0drrLKsCvFtzCkHytkTVqgfmT2fq01LWRhT
         cvvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788440377; x=1789045177; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BmAdg8/mefR05LTJz5ypL2PwZdELomAbn6h2iC+gq4s=;
        b=KGq7pZyRhvg0iwcQkC+y8SYbuqEpK7Db/gbNdQV9f0E705kzEevLygY1soF7CFAOKh
         iX00NlWGSVCmeWX/U526g+aXO4xakGzax+Pn+I4Ha7AxtUWeMKEEoJmb8O0PsdTx1RrP
         LZHk7ysHXKzgj3MIGyPKsLOm9gLt0v9oAqud9UoCg1Bb1RqKERcV5+OXW8monqHH3MdG
         Y/H9bBfFTGa3wzx3vR+iNxLFRUyvLM8KSEd/OddFgftSv9uppzmHHcXshs/pWVpdPeTI
         rMu7v9h2eup3vbPU1q2kX0lUUyL0pXTcASCc9MiMZX9ziDebhZYoFe+zndbCj00rRuNN
         qADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440377; x=1789045177;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BmAdg8/mefR05LTJz5ypL2PwZdELomAbn6h2iC+gq4s=;
        b=SQwQAlLAl0IJU8IibOsqwsP92bN+TPDeH44pCG6JCW0CY+RG77WL2Ic4xVkRlkHToS
         AKhtMJrzWYGVzQS5thSRynStScvULSp2PLGKtEUUDxjX3LR7KjoKsTrcvRoM1K4Q1Y0m
         KqgzP/hpIP+EUkOR6sdXj1/SDSJL5vMCIQW73VkxZXK40hs9F5lOLAZ32xoYI83pxaal
         +BbHqqjAc04+G5cAxdX2W5TZ9FgGhgaFoj2PzVnN8uBYUMwt/IPtugewdXSLksSwUxXC
         JozvWHpWB/iwjHAT4XMmRzkO5ypDCFXZeormwTKGW3YVyGOj2gXJaHcif5exrO5fLSyQ
         4PAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzujIbZXcSJhoVCbVJWK0MwZ3uEnmHvITP+QH1EuBAtdjhJC2GqDHTYl3QbkpAeJh0/Z1JTRdLwKQ==@kvack.org
X-Gm-Message-State: AFuF++nYJ48TTFM1UjAqwx/qM9I0JDraJA+zd0TMcCfl/KSQgOzg9U+I
	jqNDQ0PcQtbt3YhUDJPzq8cBCBaECowwoW7VRzUsrbqtmY7KUdA+971yiG6p2AmTEsqK0FdGNDT
	tf+dllzUT/7iGquNLlvQcZm/y0QiPhqs=
X-Gm-Gg: AYBFou3A99JSpz3pybQr+m7u9aIdl7xfnEi5DeD0qfIV3Bg/RpACJlMFWSaYH7rOZzm
	Iw1a2ekzEC59DsZiGkviK1NIqGgBLeu/mknlRz7CeQ5PmB9B6D1k00h+20MLKo/BbFDHBcMWpv6
	mff5wBKucUsjl9yoZVhUIpYWfptxIL6U6lhmpZ4MBijd/EUxFHILMANTV8ap195Q+gzzUZ805Zy
	x96SbresWtK0OEDSDaFibqi0jwgn6bsoQYXdNS4JA0zgbD88QNsN2FQ0z661jw8KlcypQxzNd1M
	PFbVPWu+YEURIUkhweWq5//MVA5PuRaJhD+wxm7aCRGd1FPvUfabvxOEVLNb3kLZ0LSsbBqQhyo
	=
X-Received: by 2002:a05:6512:450a:b0:5b6:10bc:dc44 with SMTP id
 2adb3069b0e04-5b610bcdd1fmr687589e87.27.1788440377072; Thu, 03 Sep 2026
 05:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-3-wujianyue000@gmail.com>
 <20260901161329.GI3004@cmpxchg.org> <CAJxJ_jhkM4HHgCi-OsQcoDeDC5_fsejf+u+b5E1n3gNUd=EJmQ@mail.gmail.com>
In-Reply-To: <CAJxJ_jhkM4HHgCi-OsQcoDeDC5_fsejf+u+b5E1n3gNUd=EJmQ@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Thu, 3 Sep 2026 20:59:23 +0800
X-Gm-Features: AcwNN1UKIFYH_nhtxWH9JjOWZK6QjiNNdqvySPxc8FL2qtcVQQ5XgTwj5a_O5fo
Message-ID: <CAJxJ_jgLNTbyXJmerardEfBzbZeR1O0J=5DwDZr1kyp0kN7qHg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C4062000D
X-Stat-Signature: d8c7ye4i559ykrhy7n4y6ekoxfu65zr4
X-Rspam-User: 
X-HE-Tag: 1788440379-531402
X-HE-Meta: U2FsdGVkX19VL0U3rijjtRW7/MEsQMqMG98SOORVoFlS04yoKRe9jfBp+fMxnxHNjHvyiEHR7ZztfB4N+MoFTUIGdAd1g8gjtPAIkiGVbFjg1zMQvU/qy4IQICR/CRXIZarkCASg3KVYY+rW8umtLW9wUK38uWSVQtnr6k+oSruPoTH7/ZBcENNJOAWes+LpeCDU9spcxyDb5jmyGGDkoVIIXrLPKXBh/QKre28F4G2xns93w9FB9R8ZhV93zOMLECN/UDPY099mV09OvJHJEm/ajfTnLltcCeey30AJoSQpQAjcfEB27E1ArxYSBOqbFR+C9DmI9x73nhw589edVYhwX0WHshstt2jjN2T1Zv4ABWKIRDYP3aCiYkT1WOlaJU9S0cPMN/3GcC5+0JoiWD6q2RSsk3w54Fl3/CddYRck0L5QhWd/gLgq89vLgTRrNGp0DS/Cxs8KcOIPsNwOULe2MiUXfk+pAMIp/7OLbfpy+9qvfpfuut3QV/EgPYh8aE0NYFNKyKeCKCS0ehpB5n6j8V8zeKqr4WmUkgfycxs+3Owq1rMaeKZlWT5qnBUCB7gAnDWxmnW+NOYnjDeON2O4SoIZYlYKufDgbmYouU2zLPU7tP0NOTOnJ6a5Q9Z3fVr36dw8TPj1xVpdnNmb5G6v4ZUOSNYDkDEkyUFRhY9q2DXLDMxtRdl6T2EIwwX01+rUskyF8dLGkbVjcHrfQgStkubEZr1R4abwBjEDJTfUI1700Dx/PdnIFK4M2gqino8rhFo9nghWtEh0DpwhNuF6265l004kqlaV38dHOvRECQelrhqS3a4VrwtEGswpPghFnh5mn5b2XmhSQk0P10DSR/2ddjHfknlpPbFg+5Fl40HqXVsxL8z3kKLa5390vffA+JMAuypk8i2o1O2W+GUDPj4eKE785lK1p2D9b7ZtNSTDv/cECLIcMlG4ZvMw/SOCaX4yTkXfMqzYk2x
 Yg6Gmcn3
 YZo3JMJGaWrymJAOpOoaZe3xqbSbfuZChUZg8A3CxyD1+Q2RNoSRDGyR2yVOgVn4amqJq0BO4lh20gZ9eYksoPzEYg9eIqso3WvZWpmRnuNMp6PoY+5Dxr20TubD4xZSQvxa+PlX01hRBy3kjHWW4Yh47UFqHRp8WAjzyGBEo2O0TqMwMXcUehlLbGnzpWWWRuZha750vncSkj0PVCc9Zofuc5ONaJJuTJ1LD0RjLe1YGQVZe7wlLlb7R2NjMDUiGlJ4jGJpQAxuTTEY9McE6S6+MeNax+e1XAfw96ELY3MqBBNTlI3/HJXR3bpRz9baXExaVYk3QewPp+l/E2mRtIP3W28sbnsD/gWayUNlICYqpsZXrZZWGlGgxPyEwX41+rB7LV8WJBZKnHy2lZXRTsRqknX+adTodGHAUP368fLx0vtMnmuV7LSFTsWktOQKJYtuE2HaHuGRYiXbDg0DUExoWdhJZi6bJfiIYszc1MfRH8cCx40P9w79dtHN2iTzgfBdq8MfD1zNuINQNBNk/cWLRrLsiRhsaWnzrdp+1XsEP4d4eHvQi3HqJKUrzufjasdNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 8:50=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com> =
wrote:
>
> On Wed, Sep 2, 2026 at 12:13=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Sun, Aug 30, 2026 at 07:47:30PM +0800, Jianyue Wu wrote:
> > > Originally zswap holds its pools on an RCU list whose head also serve=
s
> > > as the "current pool". Only a handful of pools are ever live at once,
> > > since a new pool is only created when the compressor is (re)set and
> > > pools are reused across compressor switches.
> > >
> > > Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
> > > has a stable slot number, and track the current pool with a separate
> > > rcu-protected pointer.
> > >
> > > Slot 0 is intentionally left unused (always NULL): a zeroed or
> > > incorrectly initialized pool index then resolves to NULL and trips a
> > > WARN rather than silently aliasing a live pool in another slot.
> > >
> > > The array keeps the same RCU publish/retire discipline the list had,
> > > so lookup and teardown stay equivalent. A fully-constructed pool is
> > > stored into its slot as the last step of zswap_pool_create(), so arra=
y
> > > walkers only ever observe a NULL slot or a ready pool. Pool creation
> > > is serialized by the module-wide kernel param mutex (all built-in
> > > params share one lock) and otherwise only happens during
> > > single-threaded init, so no two creators race for a slot.
> > > zswap_pools_lock still serializes the store against a retiring pool
> > > clearing its slot in __zswap_pool_empty().
> > >
> > > Behavior change: the fixed array bounds the number of simultaneously
> > > live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
> > > whereas the old list was unbounded. A pool is only live while it is
> > > the current pool or still has stored pages referencing it, and pools
> > > are reused across compressor switches, so 15 is far more than any rea=
l
> > > configuration needs. Once all slots are occupied, creating a pool for
> > > a 16th distinct compressor fails: zswap_pool_create() errors and
> > > returns NULL, and the compressor switch is rejected with -EINVAL
> > > rather than silently succeeding. The cap can be raised by increasing
> > > ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).
> > >
> > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > > ---
> > >  mm/zswap.c | 97 ++++++++++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 72 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 0bb30e58950a..b3b5e2887c00 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -13,6 +13,7 @@
> > >
> > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > >
> > > +#include <linux/cleanup.h>
> > >  #include <linux/module.h>
> > >  #include <linux/cpu.h>
> > >  #include <linux/highmem.h>
> > > @@ -154,12 +155,27 @@ struct zswap_pool {
> > >       struct zs_pool *zs_pool;
> > >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > >       struct percpu_ref ref;
> > > -     struct list_head list;
> > >       struct rcu_work release_work;
> > >       struct hlist_node node;
> > > +     u8 idx;
> > >       char tfm_name[CRYPTO_MAX_ALG_NAME];
> > >  };
> > >
> > > +#define ZSWAP_MAX_POOLS 16
> >
> > It's unlikely to happen, but this is a super annoying failure
> > mode. User would have to kill something, delete shmem/tmpfs, or
> > swapoff. And it's not obvious which entries are in which pool.
> >
> > Wouldn't an idr make more sense?
> >
> > > @@ -270,6 +283,31 @@ static void acomp_ctx_free(struct crypto_acomp_c=
tx *acomp_ctx)
> > >       acomp_ctx->buffer =3D NULL;
> > >  }
> > >
> > > +/*
> > > + * Publish a fully-constructed pool into a free array slot.  Pool cr=
eation is
> > > + * serialized by the module-wide kernel param mutex (all built-in pa=
rams share
> > > + * one lock) and only otherwise happens during single-threaded init,=
 so no two
> > > + * creators race for a slot.  The pool is complete before it is stor=
ed, and
> > > + * zswap_pools_lock still serializes this store against a concurrent=
 retiring
> > > + * pool clearing its slot in __zswap_pool_empty(), so array walkers =
only ever
> > > + * observe a NULL slot or a ready pool.
> > > + */
> > > +static int zswap_pool_assign_slot(struct zswap_pool *pool)
> > > +{
> > > +     int i;
> > > +
> > > +     guard(spinlock_bh)(&zswap_pools_lock);
> > > +     for (i =3D ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> > > +             if (!rcu_access_pointer(zswap_pools[i])) {
> > > +                     pool->idx =3D i;
> > > +                     rcu_assign_pointer(zswap_pools[i], pool);
> > > +                     return i;
> > > +             }
> > > +     }
> > > +
> > > +     return -ENOSPC;
> > > +}
> >
> > It was kind of overdue, but with this now requiring a pool walk as
> > well, it would be better to factor out a find_or_create function?
> >
> > Something like:
> >
> > static struct zswap_pool *zswap_pool_find_or_create(char *compressor)
> > {
> >         struct zswap_pool *pool, *new_pool =3D NULL;
> >         u8 id, new_id =3D 0;
> >
> > insert_new:
> >         spin_lock_bh(&zswap_pools_lock);
> >         idr_for_each_entry(&zswap_pools, pool, id) {
> >                 if (pool && !strcmp(pool->tfm_name, compressor) && zswa=
p_pool_tryget(pool)) {
> >                         if (new_pool) {
> >                                 pool_put(new_pool);
> >                                 idr_free(&zswap_pools, new_id);
> >                         }
> >                         spin_unlock_bh(&zswap_pools_lock);
> >                         return pool;
> >                 }
> >         }
> >         if (new_pool) {
> >                 idr_replace(&zswap_pools, new_pool, new_id);
> >                 spin_unlock_bh(&zswap_pools_lock);
> >                 return new_pool;
> >         }
> >         spin_unlock_bh(&zswap_pools_lock);
> >
> >         new_pool =3D pool_alloc();
> >         if (!new_pool)
> >                 ...
> >         new_id =3D idr_alloc(&zswap_pools, NULL, 1, 256, GFP_KERNEL);
> >         if (new_id < 0)
> >                 ...
> >         goto insert_new;
> > }
> Agreed. Hitting the 15-pool cap would be an annoying failure mode, even
> if it should be rare.
> I will switch this to an IDR with IDs in the 1..255 range, keeping 0 as
> the invalid entry value, and factor the lookup/allocation path into a
> zswap_pool_find_or_create() helper.
>
> Best regards,
> Jianyue

Hello Johannes,

I have this working locally, but I am still testing and some parts still
need clarification.

1. Could I use xarray here? Similar to idr, can naturally start from 1,
and zswap already uses xarray for the entry trees.
i.e. the pool table is an allocating xarray (XA_FLAGS_ALLOC1, ids
1..255, 0 reserved).

2. Compressor updates are already serialized by the param lock,
and the only other create path is zswap_setup() during init (or when
enabling zswap). That does not run alongside another creator, so I
think we can keep the simpler lookup-then-create flow. It is almost
the same as the original list code, just using the xarray API.

Best regards,
Jianyue

