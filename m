Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AF5CD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FB16B030D; Sat,  9 May 2026 04:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A103D6B030F; Sat,  9 May 2026 04:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF076B0310; Sat,  9 May 2026 04:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4816B030D
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:48:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3766E160589
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:48:11 +0000 (UTC)
X-FDA: 84747254382.29.24E237D
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41E2C80002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:48:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V8RQnDs3;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778316489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3qF25jvgZAKkMW+NjZ+nl1TbSQf0Fcc08uA3kp981w=;
	b=KiCn615ELMUPm+rdNFbL1G8Nb4wzvDNt6Va/iTmY/hq84bu+83zlfhsHdpLo7YVsEgVvuY
	9RDkCD+vUcY/P9TXLqTdY1rrIqHHjeRKIoXixBuq1VnA2P/MTgNDUrOERybB2fH5LKAXPp
	A1H4illAeOuadEzYjjYCc3t7ka7vzV0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V8RQnDs3;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778316489; a=rsa-sha256;
	cv=pass;
	b=y3P7YyNt6T7Lm9MVWs6Q50AbLfyHSlzDMThN4L/uuICpqAsYxQKkwohzYlF6xzGoFcawWQ
	SCYCQMMlWtRFlKlQwazUADgSviJUqxD5Of6nS7h6HpbrgmMVS0dUepryTzU2AftFPQLpEB
	Lll5h/Uu9xhFaM9tBZYBc2WzNHf35OI=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-651b4d09141so2821070d50.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 01:48:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778316488; cv=none;
        d=google.com; s=arc-20240605;
        b=jtDbfH/WfDLwiHY3ixLv95e6Xt8EkG+db0ZfrLQs2uKOj6GQPSNsox0If60OPjhGFE
         3snT0tvoiCz/DfYSyYdnVHURV2P3Qejpa0HwNnf9ud96De9FncRZByBP7UjFiBA/D815
         ghvkGq6CXo9VPimKvIt6FqoeMmvZyFgV72ZQ1F9xNjUCOjAXNJgfp1lJ0mPRXl/gybJC
         KWbHLMd9O5fZYXltASWQg/AXgo4+NxnVqCw0TBZZjwuujB0FKYvMcSJT9kpxCM9pyxMf
         bZZTJfGSz02S70ONKWriTz3w84lGpNKDA8004HWOJHsCIxRdifmJBTJceLDQLj31vKOg
         6/HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K3qF25jvgZAKkMW+NjZ+nl1TbSQf0Fcc08uA3kp981w=;
        fh=hkAzYvs03tTn7NV3nDm+JfT0s0xyfOM54XV6qEfbEng=;
        b=Y5S+/6PTpn5OyDLScEgqNvCuaaJ7vmFrq7MF9T41FpqbzV+H775sfAv4tapP59Y9jP
         PeYig+6+y1oJTWlLGwRkM5x87WaJvRpr61R6NhfLBKAqo4BQroj5dyMD7ylVSFIeWZ8Z
         sW64if01AgEzKYHVT88Yx7crbClLHIiN6tx4N1xgy9W++Bw4iqHbmJxWjm0f6M5Cg/nD
         7RKpd6E8Oqcug2Mks1t63zFm8E+0Gjj0uoN9AMsxB84/Zx68kwzTSzuKt9JQ47mEezFh
         KTEwX7IJ2OKdIkKBdPc7jPGAhAB/yECZP514aEWcUfv2ZtbRhglBIprEh3EMhrclBBFT
         5V4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778316488; x=1778921288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3qF25jvgZAKkMW+NjZ+nl1TbSQf0Fcc08uA3kp981w=;
        b=V8RQnDs3/bCbe/y7ZUDOH+1EXG1jqNO9NDMFMmzxnrnDWTgqWiwfU6Xofvneleg5IH
         JVqYSqskli6xkQK3MjiEs5L+HjLpFuN0DP8bsfjmpZCN5wUBKZ9ZWhiG7692IbT9M6x9
         nFQoGK4IPo/BA5vf57N82V6UDx1E2Jd8bn5ThL5gdPeCr/yY+iQxjCdvu2uspFeGZyWM
         KKEZChcXIAuGwPGTchQh6FbcDWhuQr5NsaoqbUz6ojXARd66el6zzuJ1pFCKUkO7y+BN
         Dau+SPpmBLoCUP4wNYzhvOssMJkpvwc9d7Yq+D/l0uHpmj6w+T50a3HTglyFrS1jy+ye
         lUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778316488; x=1778921288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K3qF25jvgZAKkMW+NjZ+nl1TbSQf0Fcc08uA3kp981w=;
        b=c++5PW7ctFqe+Jh8Ol3JJdaOj/4yRwW+sgxxvLfxwa+vGIwHwFZdMO/MZfaWVP6yGy
         iqxI1ifdyavDQ5KIRAoON25IBLD2atmI6GL0n8FQrMdGlIN6ZdiPcuhX4sXd09b3oQZ6
         27hNKQRAYHvzlwlnaPdd6/PbqW8Vnb99n8HqD4yHrruuLB+k8SJ2pOnQ8PKZz5Jy92f+
         q6DRUz6fh19YMouGcYFmN04/GcJD+FKqF/3qbNWCGyL08sRqW9HHLgchfjwlW6IM3Cl1
         2cp9+FhaZPgs39asDQVZgQE8JIxu7aFsFyQgM8K67vlSLKOFf2goSwihrVM4/xw0L+uZ
         Nhqw==
X-Forwarded-Encrypted: i=1; AFNElJ/eroMyz8oS3lM/P4+QG+L/psLkq1kPrS2PzDQflqSgf0AU7krL/V6DdJmLxQwycuVR39NOUMkrPw==@kvack.org
X-Gm-Message-State: AOJu0YxP3NtJdXJbOH3uZMpowr3L2YgArhaigzKdY5QzXNBSAZz6J9Nl
	LqFcY0OqjBKHoV49wEpej9yxdANtELoPY2rsKxo1VOwyQgF3jXJOvRZ35zmh6hM3eSCgD8XBhHY
	sjTWEiidaDPCA66/VDww8MwkJOskCrco=
X-Gm-Gg: Acq92OERpTbjraKoJ0tPt9vHf3/bYc54IeFYxx8ELjyriehNQl6O3U616llxQFfBtVN
	8QgYOdklviRxZ6DtXlN/p/Z4mI6Cn6aVCZq29wLm94bz7+sJsfimkOvC0SEevHtC6Vdb4If+IMP
	tfTHH6lfV3/2s0XIyF0LT1D/ikIliIwCwG0HJE1kdCjzLjTAEm+FE+ougyuRUwHLzsQc2gmHxD/
	Xdk4VmPmN31DWzIW591AwNrQwIAEVOIqYri8AjS02X4buyRRvAaaFOCt/zwOhqwHdZiqw4rDjBv
	fsetNFVc
X-Received: by 2002:a53:ac8b:0:b0:651:c41c:80ce with SMTP id
 956f58d0204a3-65d7e782ee0mr9032266d50.16.1778316488245; Sat, 09 May 2026
 01:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
 <20260508060724.3810904-2-haowenchao@xiaomi.com> <CAKEwX=MzLKTF2uQRaJU8UK5B9UeW-Sh-LE_8fdmo7y-MPPbwyg@mail.gmail.com>
In-Reply-To: <CAKEwX=MzLKTF2uQRaJU8UK5B9UeW-Sh-LE_8fdmo7y-MPPbwyg@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Sat, 9 May 2026 16:47:56 +0800
X-Gm-Features: AVHnY4It_UXh4NngbQgPwWNgoNxLei8GvwX1tCgHjP3tCsKGiSXiBnVS9MeknAQ
Message-ID: <CAOptpSMaAEDMfGOufrWkJY5VchFBx+ON=Uc1j19JP5vw_wJdEA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/4] mm/zsmalloc: introduce deferred free framework
 with callback ops
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41E2C80002
X-Stat-Signature: cfyd6k75oxrkhm84pp5zu65nfire35es
X-HE-Tag: 1778316489-2861
X-HE-Meta: U2FsdGVkX180sF+QROZaRmTc6DJXqujDfxKL2UhctFe6ICNz1V6rw65TlvM0htF68fJA/1CrOhSsQ2ixCc++w6MRMOTi/AHi/RHvtDqieyzMoCTyqheDSZj3DjtJEUWddgFpBl7fp2J0g79BuDHOZKDDfWCXgHXA/98cOE3Ust0OaWSdXUBuwOWLsqrIQ33p7/LwFkA6Js/cAK/Sso2U3llh02WEW6x/rYehrBPOwkvqlgH8pBmXfgpd3dijUKgqp5Md/BIV/zAAkQQnRohh/guJHAKUGBXEBSNlWfqgz6NFmDLqoGUnm2QUUeaDGjHAVrG4mSafynHqGMhAun75e1evmP8QFJbhsbXLJgfbmvX0CmwhKFGZsRC6PDXC8fmmlnZFiwOiTKFeRIPej8vc68Fgh7HyvMYPV+40ur2eo/9nKZNeqJZPCm+8r4kIAikHyGwlSNlhHnXxagmE5U93Qbjh8IbiWqw/3c7R2Cv+7KCPmxZAgPIeMxXpT2P5fA3wW1zWT8ngAHG6NkJbFxd510bvZwFUxPKVOzHSjCaJXJnKxV4XCfb3hT1P/DNqsL5UiEyuWcxI7Ahs9azqvCMy7SoGKnBdsi6QgFoQE+Y8m76uaQvYXyEByxCo4nfa1c+SrS5Sfv3lF4wiFD6pHLUG9AotSqng2u7xMw3vPz649bK1jRt0jG0vK/4RN6lXa9vq+O6OLER3iMGSLWFvPzjuWgrcSV/qBU6avk50GN7pdgeYZ04prqAxd7EkWITywgXGXWOtaamRy/h/Jze006br1AnfAK9s3kp3FpufvSx4jIuwynw0yLEfHPAzGzd4Rm1XGmdqWiQb6RqY5aT+bQTo3HmtA6vCCC83YVS5ASjcL1r5a+kucydzg2UxvDCbxukT3tOQZhLZ9oLeBUIt1C7ujzKxRaZCMfBIMy6yByfExfVko2+zGfsBbzFxcdnvyOu8CJAIRiPx2laXFzhu0Ht
 Ei5g3izz
 KFzpaKphuKDjuwGRWjf6wC9lY0V07gmiNY3DxAbQH/Ikf18hjpXf7CJ7kCQ7HtGe1wq256k9ry/qQaMHy+RzoFUzRCxtl4UqgF9D6ZN1FziGdpn4A4qqBEzCUhy7XhJuQNs+oUxDduj/3lX4h0eVPzlepmMCQzq+Ae+jluDYZd4pxzCAgRfK5EjA85/5txM2sIyHw36a7gAmKWtXsrFCiXG2RPmkcPqDXib/JnxvVtJgEGX5UZAS2fGLylpBpQfFQXCYwEBJG/YADVmPUWaeJ/OEA3AWVvxfLSAzzZ0DMIGVw0OxMWGguENG1LMnR+1T91mA1vOBPTF41Cierz4l/5vxyblPlvjUNho0sKo6UY20ioYlW7hsR4EtFaCB1sGpK+Mp3vVspUlA0AOL9P4Myo7oELzQUYwbKz1Wwgl5qdJZIToWRDolLMPL/ns4FMM11IwMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 8:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, May 7, 2026 at 11:08=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > Add a per-cpu deferred free mechanism to zsmalloc with a callback
> > interface that lets callers (zram, zswap) customize push and drain
> > behavior.
> >
> > Each CPU owns a single-page buffer. The hot path (zs_free_deferred)
> > writes a value into the current CPU's buffer via the push callback
> > with preemption disabled =E2=80=94 no locks, no atomics. When the buffe=
r
> > fills, it is swapped with a fresh page from a pre-allocated page
> > pool and the full page is queued to a WQ_UNBOUND worker for drain.
> >
> > The drain worker invokes the drain callback which performs the actual
> > expensive work (zs_free, slot_free, etc.) in batch, away from the
> > original hot path.
> >
> > Page pool management:
> >   - Pool is pre-allocated at enable time (ZS_DEFERRED_POOL_SIZE pages)
> >   - Full buffers are drained and returned to the pool
> >   - If no free page is available when buffer is full, the push falls
> >     back to synchronous processing by the caller
> >
> > Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> > ---
> > +#define ZS_DEFERRED_POOL_SIZE  (256 * 1024 / PAGE_SIZE)
>
> Seems oddly specific? :) And this doesn't quite scale with number of
> CPUs, or memory size?
>

256K holds the deferred metadata for ~128MB zswap or ~256MB zram
entries, which matches what a killed process typically has swapped
out. Pages sitting in the pool are memory that can't be used
elsewhere, so I didn't want it to grow with RAM/CPU. Happy to
parameterize it if you'd prefer.

> > +
> > +struct zs_deferred_percpu {
> > +       unsigned int count;
> > +       void *buf;
> > +};
> > +
> >  struct zs_pool {
> >         const char *name;
> >
> > @@ -217,6 +224,18 @@ struct zs_pool {
> >         /* protect zspage migration/compaction */
> >         rwlock_t lock;
> >         atomic_t compaction_in_progress;
> > +
> > +       /* per-cpu deferred free */
> > +       const struct zs_deferred_ops *deferred_ops;
> > +       void *deferred_private;
> > +       struct zs_deferred_percpu __percpu *deferred;
> > +       struct work_struct deferred_work;
> > +       struct workqueue_struct *deferred_wq;
> > +       struct list_head deferred_pool;
> > +       unsigned int deferred_pool_count;
> > +       spinlock_t deferred_pool_lock;
> > +       struct list_head deferred_drain_list;
> > +       spinlock_t deferred_drain_lock;
> >  };
> >
> >  static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> > @@ -1416,6 +1435,171 @@ void zs_free(struct zs_pool *pool, unsigned lon=
g handle)
> >  }
> >  EXPORT_SYMBOL_GPL(zs_free);
> >
> > +static struct page *deferred_pool_get(struct zs_pool *pool)
> > +{
> > +       struct page *page =3D NULL;
> > +
> > +       spin_lock(&pool->deferred_pool_lock);
> > +       if (!list_empty(&pool->deferred_pool)) {
> > +               page =3D list_first_entry(&pool->deferred_pool, struct =
page, lru);
> > +               list_del(&page->lru);
> > +               pool->deferred_pool_count--;
> > +       }
> > +       spin_unlock(&pool->deferred_pool_lock);
> > +       return page;
> > +}
> > +
> > +static void deferred_pool_put(struct zfs_pool *pool, struct page *page=
)
> > +{
> > +       spin_lock(&pool->deferred_pool_lock);
> > +       list_add_tail(&page->lru, &pool->deferred_pool);
> > +       pool->deferred_pool_count++;
> > +       spin_unlock(&pool->deferred_pool_lock);
> > +}
> > +
> > +static void zs_deferred_work_fn(struct work_struct *work)
> > +{
> > +       struct zs_pool *pool =3D container_of(work, struct zs_pool, def=
erred_work);
> > +       struct page *page;
> > +
> > +       while (true) {
> > +               unsigned int count;
> > +
> > +               spin_lock(&pool->deferred_drain_lock);
> > +               if (list_empty(&pool->deferred_drain_list)) {
> > +                       spin_unlock(&pool->deferred_drain_lock);
> > +                       break;
> > +               }
> > +               page =3D list_first_entry(&pool->deferred_drain_list,
> > +                                       struct page, lru);
> > +               list_del(&page->lru);
> > +               count =3D page_private(page);
> > +               spin_unlock(&pool->deferred_drain_lock);
> > +
> > +               pool->deferred_ops->drain(pool->deferred_private,
> > +                                         page_address(page), count);
> > +               deferred_pool_put(pool, page);
> > +               cond_resched();
> > +       }
> > +}
> > +
> > +bool zs_free_deferred(struct zs_pool *pool, unsigned long value)
> > +{
> > +       struct zs_deferred_percpu *def;
> > +       struct page *new_page, *full_page;
> > +       enum zs_push_ret ret;
> > +
> > +       if (!pool->deferred)
> > +               return false;
> > +
> > +       def =3D get_cpu_ptr(pool->deferred);
> > +
> > +       ret =3D pool->deferred_ops->push(def->buf, def->count, value);
> > +       if (ret =3D=3D ZS_PUSH_OK) {
> > +               def->count++;
> > +               put_cpu_ptr(pool->deferred);
> > +               return true;
> > +       }
> > +
> > +       if (ret =3D=3D ZS_PUSH_FULL_QUEUED)
> > +               def->count++;
> > +
> > +       new_page =3D deferred_pool_get(pool);
> > +       if (new_page) {
> > +               full_page =3D virt_to_page(def->buf);
> > +               set_page_private(full_page, def->count);
> > +               def->buf =3D page_address(new_page);
> > +               def->count =3D 0;
> > +
> > +               if (ret =3D=3D ZS_PUSH_FULL) {
> > +                       pool->deferred_ops->push(def->buf, 0, value);
> > +                       def->count =3D 1;
> > +               }
> > +               put_cpu_ptr(pool->deferred);
> > +
> > +               spin_lock(&pool->deferred_drain_lock);
> > +               list_add_tail(&full_page->lru, &pool->deferred_drain_li=
st);
> > +               spin_unlock(&pool->deferred_drain_lock);
> > +               queue_work(pool->deferred_wq, &pool->deferred_work);
> > +               return true;
> > +       }
> > +       put_cpu_ptr(pool->deferred);
> > +
> > +       /* ret=3D=3D2: value already queued, will be drained eventually=
 */
> > +       if (ret =3D=3D 2)
>
> =3D=3D 2? :)
>

Will replace with ZS_PUSH_FULL_QUEUED, if v4 still has
this logic.

Thanks,
Wenchao

