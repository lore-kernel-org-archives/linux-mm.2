Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB63C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562416B0088; Tue,  1 Sep 2026 20:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5133F6B008A; Tue,  1 Sep 2026 20:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401DB6B008C; Tue,  1 Sep 2026 20:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166A26B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:50:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB884805AC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:50:46 +0000 (UTC)
X-FDA: 85166992092.15.CAAA65D
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1BF81C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:50:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+Bzeac+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788310244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqPY/O+R8Ye4De8eSkETHoBdfpmFjPEzhn9lUdJii2w=;
	b=Hw0XMT/QuzgMqjWZml/L0i/x3xdTZ1Te22jWp3b/P9x+tnHe8cnTZnS695Z0S0Bf5rQpaL
	ZWDJheyyE5IuqbZp+ZAbBDSuI6q9ATvBZ27jXSeAvPX4rlVfjK87FaxPb2r1Tm8tW+NQPT
	pKwcavfXgs7J77QpjGjlrdf3Bok9/TE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+Bzeac+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788310244;
	b=V9SWc6nQ6xzl3x3kY4WtmYGRqQ0oGDIumvQy4ZmzSFRwGCxDAKoxGGUOMlivDsQgwbj9pv
	dtE2eF7gM3/Tel2uVtGNbPkwF3B/ElrlZSJVAcMp2oQY4UmwwQmz6x+8aUexVAh6ysYjeR
	dfrXvAQEqZ9uJMzFpDK/3o8iKa6NsYc=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b6036e9c70so369610e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 17:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788310243; cv=none;
        d=google.com; s=arc-20260327;
        b=PBAPyQC40zpCbVIhqJnbl1WD0WYG2v/mhen/+tUs7Zf7AQ1MQ4vDMLpjofqsVmGFW9
         xkhfQ70IROYLvaNDFtJHfSU7Yi7XwG4wjDBTJHr/u99GfcWoB+O/iN9p4Bi8NwQekvaH
         5gKbU3OQYbYkAtOlGB+2dVnwSWDvYBfGHUnKUdv8r0TXYAriqw8AWDOI/eTyM91/1h75
         qvCuuqdo+pPNae47SF8QiX9SLRZYR1PLiH57TaeGjSSvhnGIfJFEfYNkpK6pVi2G2C1K
         bC4KqppkRor1SWxzGonNVMQiHTT99BViGo9u5kUoiG498SrpawmcqJ/hfdzILxO1U0UK
         iyyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hqPY/O+R8Ye4De8eSkETHoBdfpmFjPEzhn9lUdJii2w=;
        fh=BO6xAcxE2qk53PrE6ZmTFpsT4WYp6vlA7mn6tjGZTDU=;
        b=GURqz1+PSdcWMiPQWZ9T04xJHdT+kt9794ECkep64m486WLka96PedQSI5mfOLw73X
         L4vI581TixSCS593e01qL9D2XBN9Nyt6wvh8Wl+sgmWLPH2l5qZ90S9jYvtV8+ITKkGl
         5c5jZBnLjLdLi5tJHEjhBYZM5AkgxG/Yi3UWTaET20V5zOSDjlDVBwHgqCstwDZe5Mmc
         WbRurgVYChjlBKDOSLjaiYlgnSuW9wUhqupvb410JX45lA2S8NDtHlimuQw/53ZW/5s+
         EhBr+8ZjD7tdFgv7tzLXHO6tvWMX0vHXuo3TMJWmtm7t0uhysWQVgkiVRtNDx1hRjhP8
         QEBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788310243; x=1788915043; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hqPY/O+R8Ye4De8eSkETHoBdfpmFjPEzhn9lUdJii2w=;
        b=J+Bzeac+Mp6UGcujOO+WJw847Ax34z2DhuKOwno4bYN0BEsE2UXZh7eT83oFYJyu1F
         tc/yHiKTn4hpVupDxVgAAiVBxcKfXvfG3CHxk5WALHWmMlyEQaCjQEODYshTLckgGaqM
         DMpwkI8l3tjvRvwILgjOrofpfXrrUK0Z9OO93ddEpyJONlnXcgk8rHh2E5DKv7zT/zmw
         nuD+AQvHZAIlESBYB+cVZHwuBhri0Yi9zuq+gbvcswQC7+CyqDJ6XzChvG+d4dVaw4up
         h7I+dsdNuqWsQA6WRT1L/sv2CFhs53oJv+A8biYgvkQEFlUvaem2d4T7c1lPUVXVHUul
         GYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788310243; x=1788915043;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqPY/O+R8Ye4De8eSkETHoBdfpmFjPEzhn9lUdJii2w=;
        b=UhGknXjBfcHPhP8UIdrvK2Rle5UfanlrVO6xe49RaDabRtXCXRCgAmrrCZ0zZ6RXq3
         ylfofijVcBq6MB5ZaIoTMW2qHwmdMcJLRvQIMLEjUmiPpOT4jqSOTPSNchOwzYUTzSRq
         /IrlNllY5ahVNFTSa7iF7zAlEu7mybTCg+Hmzto512syqugTTL2rKMvajcV9zxLK6bH5
         WO+sKYssCUJzchgSRBAaEEhNvGOVRoZ5OSTYtUK2bHBGvpvHVp8X9tY0EOQVN3IvjzuE
         VLjb/BYpwsblgxiKVaFqB/R2V3RFeyP9vAwB9mphObWheo5sDnT4I9bYXZfDI4DflyG6
         Jobw==
X-Forwarded-Encrypted: i=1; AKwUvBw15Ah/VSDrLvvu4WxUluZNccrLts54UaCLP7qii+z1dNo3WY4KZ2Q5D+zQGiIF4O1YW593stLtbA==@kvack.org
X-Gm-Message-State: AFuF++lvjZI5rcRreh9YSYBj53CS20iqmxaY5XzxjtMosRnDwmF45wdb
	AtBn7mGyja4ovCqDTROr8m6phNnXbShkf0Vi6bLc/awFL0hUE6R4VzSLOcqzYtFVttGY92BfKvq
	LTffi7yXh/gI158sUt2dJNHxLVrC7f/o=
X-Gm-Gg: AYBFou04AkFtqeHMIN1pfYYMqSt3gtrV5gUw+9ktpGAB0xvKAeKQ+U9mMBOQxqqc49f
	eWnRy1uEoPrycLJ9zsJdJY+3eCECeMZMrWEEoJD8IN+Pye7lkMvzSS9F4SgtCI7fhMh2gys9vA3
	lBBj7qiTdUXncoB+oxighxxZ6UNVvzht2d2j2EFiAcyXrd0G7I0h/VTpv0lxAf1MJ4TXrPZX1D9
	OqN5Ay1lGa4mVNt5lN/3pGzCf0tPjkKGsd0oOfzAC5TTddqpuer1ESjLTBz4BTdpwTIzNH4jKkS
	f3YtHdrLNuiN28W8Sf77JDSMz6c7z/CGBQ+RkdQIF0uJyA0A1+D/2NwUh7STKPZCn4kJuon0yg=
	=
X-Received: by 2002:a05:6512:15a9:b0:5b6:4ae:5b7f with SMTP id
 2adb3069b0e04-5b6087d6133mr353785e87.29.1788310242499; Tue, 01 Sep 2026
 17:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-3-wujianyue000@gmail.com>
 <20260901161329.GI3004@cmpxchg.org>
In-Reply-To: <20260901161329.GI3004@cmpxchg.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 2 Sep 2026 08:50:30 +0800
X-Gm-Features: AcwNN1VZP9I5AiwbB0AJlzk0UO5pYmHN9ADWJl1TgGW01163D6x1NbqVrjb50eI
Message-ID: <CAJxJ_jhkM4HHgCi-OsQcoDeDC5_fsejf+u+b5E1n3gNUd=EJmQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1gcnf85z9n479zqf9z8opzrbj6rz5tn7
X-Rspamd-Queue-Id: B1BF81C0002
X-HE-Tag: 1788310244-531954
X-HE-Meta: U2FsdGVkX18vEbRuaUQfagCfK4zdQNPhM7x91luY0dKJIVL42T+M6PipFBXfXxin+473Q1QVswjDo7ScemIlTwAgmmc71xMDG4xoTbnzQyXZmrs4zNtsDu8mgaIKKsMKbI8+XSkbrzOB8k+A/XgupuQByzFBJ8vWt/+/210RhTsS8oUMCehr6y68iUBstXadV9WF99W5LcmA9NUARLFlPmsLnZBV3vLbSQ9bUmgIZXIQ50DaKNdGgLG9gI9W710vqT7D+ifPsnLgjzHOGO2/xUHx7B4tCzBtjE7y056pKu7AmjJGaUVe8ROqwgDIHSYKTvx7OWIxSfEim0F20VrfnZKmv1JLkRr+utHGreH5fP+KBrpMFQc8YSLxwqkk7RbFOZaA+u9H1onIBOYv+mcAiEtlP4CYlGUPhKWmNNMeQf4VN1ky168tiBgqn3o8kD/z/+fTV4j45LI0yN8j5sxx42yRr7XZ40jc1HkwcOgJP3tZU8Zzab2+HvTclFbulRqPKpMkOTVQCuwglVHqQXqBdZBZXrNHM1rmxsEhISSXdo+3xINdZbZEDzTwQBOFVGpoT1zZInskAtSJHVGZ7AP6Zu00ZRwJUZ3YZkiShm+oDc1k4LLdzMixq9s3wlW20WTXyYyhvWMQ1/nVdFFzO0B0o5jHid43wDREFvIksA8BPoVjGJU/T95QARd45MfUB5bMsxeAyAXZT6G+RoOTGgFUbTDaMPNRxaoWy2I40+oJbFk1ZIAUlOQidt6dYPJHVOR1N1f8jzNBiUyYcds48VRdOdtvdH+FEHVzIDBjAaOkQcV4h8RJSphRMdZyqGYdXbwZP3P/BuD0lylpFvJ8o0DY0SlnafuCBKpclvVObo5tU2SY+AvuW6iLTi3epumfN8OAa0SF3PIhUUxXDSPhtwwhpIXqTuIOuqw62StsBp6HDzbwTnOiSO3CVfuKQr6RBBGBXmN0pdzdroHkmy57/DM
 srmmR0yV
 OmmDDmXLrWhtpWHL7nkeaxfF7mvrTkCllShLht7dS+Grw0tFMXHryI2KoDP4K7gMwJCHZhlEuVUmv8w6EgpGMe3VUumlGxhYS8KfH4SRu4UDDqbBaDiPCcc67GA33Rf7J71ZgeZ/eRd95Ncc6eBBBo0/XIQPekCTAY421Tr9owQI42w4L9CLOoV8mSUAN7dqUbb6A7I7E5x1YueMB6K7wmWA9ta6FYnwwBwVW8Lw+Y+9a7csU6kt1OUFn3La3ZoCtafjXE/rGLQX0oOjwGWg+KvpzozvBBIffjf1gOUXQXIWmfsGI0bARKEhKS0SV/yJZiITgi+7D98JtxddWvjQdHnHAcZrXcKi/MDKTrSseBgRJ9vmgHjb6J3jwXe+3unCsT0ZBxFdI7UNo/mKTaaa6RcUC40A97Y33RFiH9qEMHBwt7iKAdkANu00sQ2wMKyRBWSMuQh4niY1bHALoS8iRHf+uAhinID6uA3KWzrODse/W3mQ7afB9uPkNfTd7+2KXUGRT9CLby8gg87zIADGGWUx0fdwaq/G1ZyZXJC+toE/DNVooag2ejpWnC+1As5vJKJ0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 12:13=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sun, Aug 30, 2026 at 07:47:30PM +0800, Jianyue Wu wrote:
> > Originally zswap holds its pools on an RCU list whose head also serves
> > as the "current pool". Only a handful of pools are ever live at once,
> > since a new pool is only created when the compressor is (re)set and
> > pools are reused across compressor switches.
> >
> > Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
> > has a stable slot number, and track the current pool with a separate
> > rcu-protected pointer.
> >
> > Slot 0 is intentionally left unused (always NULL): a zeroed or
> > incorrectly initialized pool index then resolves to NULL and trips a
> > WARN rather than silently aliasing a live pool in another slot.
> >
> > The array keeps the same RCU publish/retire discipline the list had,
> > so lookup and teardown stay equivalent. A fully-constructed pool is
> > stored into its slot as the last step of zswap_pool_create(), so array
> > walkers only ever observe a NULL slot or a ready pool. Pool creation
> > is serialized by the module-wide kernel param mutex (all built-in
> > params share one lock) and otherwise only happens during
> > single-threaded init, so no two creators race for a slot.
> > zswap_pools_lock still serializes the store against a retiring pool
> > clearing its slot in __zswap_pool_empty().
> >
> > Behavior change: the fixed array bounds the number of simultaneously
> > live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
> > whereas the old list was unbounded. A pool is only live while it is
> > the current pool or still has stored pages referencing it, and pools
> > are reused across compressor switches, so 15 is far more than any real
> > configuration needs. Once all slots are occupied, creating a pool for
> > a 16th distinct compressor fails: zswap_pool_create() errors and
> > returns NULL, and the compressor switch is rejected with -EINVAL
> > rather than silently succeeding. The cap can be raised by increasing
> > ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  mm/zswap.c | 97 ++++++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 72 insertions(+), 25 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 0bb30e58950a..b3b5e2887c00 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -13,6 +13,7 @@
> >
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > +#include <linux/cleanup.h>
> >  #include <linux/module.h>
> >  #include <linux/cpu.h>
> >  #include <linux/highmem.h>
> > @@ -154,12 +155,27 @@ struct zswap_pool {
> >       struct zs_pool *zs_pool;
> >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> >       struct percpu_ref ref;
> > -     struct list_head list;
> >       struct rcu_work release_work;
> >       struct hlist_node node;
> > +     u8 idx;
> >       char tfm_name[CRYPTO_MAX_ALG_NAME];
> >  };
> >
> > +#define ZSWAP_MAX_POOLS 16
>
> It's unlikely to happen, but this is a super annoying failure
> mode. User would have to kill something, delete shmem/tmpfs, or
> swapoff. And it's not obvious which entries are in which pool.
>
> Wouldn't an idr make more sense?
>
> > @@ -270,6 +283,31 @@ static void acomp_ctx_free(struct crypto_acomp_ctx=
 *acomp_ctx)
> >       acomp_ctx->buffer =3D NULL;
> >  }
> >
> > +/*
> > + * Publish a fully-constructed pool into a free array slot.  Pool crea=
tion is
> > + * serialized by the module-wide kernel param mutex (all built-in para=
ms share
> > + * one lock) and only otherwise happens during single-threaded init, s=
o no two
> > + * creators race for a slot.  The pool is complete before it is stored=
, and
> > + * zswap_pools_lock still serializes this store against a concurrent r=
etiring
> > + * pool clearing its slot in __zswap_pool_empty(), so array walkers on=
ly ever
> > + * observe a NULL slot or a ready pool.
> > + */
> > +static int zswap_pool_assign_slot(struct zswap_pool *pool)
> > +{
> > +     int i;
> > +
> > +     guard(spinlock_bh)(&zswap_pools_lock);
> > +     for (i =3D ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> > +             if (!rcu_access_pointer(zswap_pools[i])) {
> > +                     pool->idx =3D i;
> > +                     rcu_assign_pointer(zswap_pools[i], pool);
> > +                     return i;
> > +             }
> > +     }
> > +
> > +     return -ENOSPC;
> > +}
>
> It was kind of overdue, but with this now requiring a pool walk as
> well, it would be better to factor out a find_or_create function?
>
> Something like:
>
> static struct zswap_pool *zswap_pool_find_or_create(char *compressor)
> {
>         struct zswap_pool *pool, *new_pool =3D NULL;
>         u8 id, new_id =3D 0;
>
> insert_new:
>         spin_lock_bh(&zswap_pools_lock);
>         idr_for_each_entry(&zswap_pools, pool, id) {
>                 if (pool && !strcmp(pool->tfm_name, compressor) && zswap_=
pool_tryget(pool)) {
>                         if (new_pool) {
>                                 pool_put(new_pool);
>                                 idr_free(&zswap_pools, new_id);
>                         }
>                         spin_unlock_bh(&zswap_pools_lock);
>                         return pool;
>                 }
>         }
>         if (new_pool) {
>                 idr_replace(&zswap_pools, new_pool, new_id);
>                 spin_unlock_bh(&zswap_pools_lock);
>                 return new_pool;
>         }
>         spin_unlock_bh(&zswap_pools_lock);
>
>         new_pool =3D pool_alloc();
>         if (!new_pool)
>                 ...
>         new_id =3D idr_alloc(&zswap_pools, NULL, 1, 256, GFP_KERNEL);
>         if (new_id < 0)
>                 ...
>         goto insert_new;
> }
Agreed. Hitting the 15-pool cap would be an annoying failure mode, even
if it should be rare.
I will switch this to an IDR with IDs in the 1..255 range, keeping 0 as
the invalid entry value, and factor the lookup/allocation path into a
zswap_pool_find_or_create() helper.

Best regards,
Jianyue

