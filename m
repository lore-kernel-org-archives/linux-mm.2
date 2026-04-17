Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42EFF99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 21:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A2D6B014E; Fri, 17 Apr 2026 17:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AA96B014F; Fri, 17 Apr 2026 17:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40526B0150; Fri, 17 Apr 2026 17:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A46C86B014E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:59:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F04C14037A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:59:57 +0000 (UTC)
X-FDA: 84669416034.18.8F5FE1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48892180006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:59:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z1bq9x/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776463195; a=rsa-sha256;
	cv=none;
	b=QT06DcTugUg+hyuWQw9i3hAH4IRI5m5kl9X8qyJsDc76mksXrbhw7CcSjoyTE973laNDET
	m4jJqh0ocsJFTFi3oYEh9ECF1xTbNgpDhX6jTUoNOjmQdwLe/qqapYUPy5fe/cIJRrdeMA
	sHehP0tUXmCdDygae2OXpu+Q3hrklKo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z1bq9x/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nd7qHuCpZjnL95oFwxOOHJ3tWSTbnGkalG4pdfPsSpE=;
	b=f/7c89IK7rTF1PJ7sdFtVVBt3UcQeKcE1+7IJ+jN6kMxKk9OzZ2sUoKwgfs8kg98DPl68S
	vvDi/c5QvptFoQKG2nBw1X+sWISz3q7qYmDFfwVsA4dSKUmBOxVtqxj9BrwsMotr5sI3+l
	s3DFBH8Z2mV1j47hRKX26zqt/CwPkK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EEF76013A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF06C2BCB3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776463194;
	bh=JaCdgcmEUHbDeA2gw7iUfkcJu19kiK3sUUgMzqWDC18=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Z1bq9x/ZiH4MJAoheHkTRVkq4JXTfRg/lftEnj6n88YSLOTjinLLMsKpV34LstEs7
	 +x4In20NNnbbyk/2txpnLlz8YfcOFlLfw+8sZZhsNm1onZ9xMbaFRLdIEACELoE5CF
	 aIxsb9ZYbFp7hqk28r1RRGJdCA3dKiPfr466jlsBmWtEJpsTn+Qa4/Zt1ylXIc0Y90
	 hdHcGZ+s7eqkKC6X23WVLYaV01dzYkv36iKMbqhlQP21GYq1WuK5FOqf1P6T6E9rgU
	 ih/W9cGMlct7oz86FzDTLDlCpF8/DM0vjzxLXbuhlbprE93o81W0Csq4cukdmba2d6
	 TGoFWwLM+RVyg==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so15918046d6.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:59:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8gyW3XiVQa4k8/DVLOV6gwNYxlHrOvBbLRlwhiuh7nlD0eqDxDI99tmEWc7HYxye3MxdATjYvxAQ==@kvack.org
X-Gm-Message-State: AOJu0YyViZ6rC9IflwjCGFX9YmR/AMlNt26liGVSwkmkFsouY7+irmpA
	LmavZY8bZ/3v6A7c2tSdz4Jr3dzM78PmT0VhzscsmPEAG/oqOWW/7thzaYg30TNRXZTQPWnheYD
	6MkT9x6/nhsgW+njAXcCVkxz08oDhHyk=
X-Received: by 2002:a05:6214:29e9:b0:89c:6bbd:76d8 with SMTP id
 6a1803df08f44-8b0280b2f12mr73952556d6.19.1776463193295; Fri, 17 Apr 2026
 14:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260412060450.15813-1-baohua@kernel.org> <adt3Q_SRToF6fb3W@KASONG-MC4>
In-Reply-To: <adt3Q_SRToF6fb3W@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Apr 2026 05:59:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zSCkDGzvpaBGAqnUSQSWx2ikmrqpihYPBhqdwC-PKDOQ@mail.gmail.com>
X-Gm-Features: AQROBzC6BuZtWVY0sxybxJ4MxSOu-q_1G8tDdEt1b4FjEKKUjwM1uiPXApMWkwM
Message-ID: <CAGsJ_4zSCkDGzvpaBGAqnUSQSWx2ikmrqpihYPBhqdwC-PKDOQ@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
To: Kairui Song <ryncsn@gmail.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org, 
	justinjiang@vivo.com, liulei.rjpt@vivo.com, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Wenchao Hao <haowenchao22@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: 9uy7teawxstj861ik4wbt98bnx6snj1j
X-Rspam-User: 
X-Rspamd-Queue-Id: 48892180006
X-HE-Tag: 1776463195-347256
X-HE-Meta: U2FsdGVkX19QAM1fiyLP3c68NihhNEoSgEjC4DnboTyepuh4hdDMY1V8B6EnopEN8ey3ZWzmOm1rLDr6108iiVBD5cdN1spEre7p1T7W8YJ1Fi88m5AUlBYH8zgUjMFVBRB8x61woax+24ScSAO4mR6ZahSSIO2grrsokQNjt1uQnOLeNrEOZqHdpKss/HNBhWRu6Hv6qWbApAIPlsV5nyp0R8viCzjrNujlnZnkVXfPTo706ophEEcyrgPIAhEBfM+zIj437EdrdC4RR+CNhQB/Cw0iXpIm9y2Isq1lm9251tMpPKmX7FZPHlmFI7kAGcvV9LTzCErJyjO9eD+9XFxUpJ+vOHX7mBnEuzvs7trwj+O8vhkocMEsQEkXOoXWm1vbqLEkbFEnzqSdOiu87AZf2P85yQS3cGyfKzmW/WSGZbAuvQ26ngTAJNGmXKJ5Fr2AcJQ944cggK/wewMeRalomP9CbeBH9RIu2cQ+kRNBnvFovPpfFQsx+0WjLnJ74hG32PepI2XCHPT4W+TpnrfNqGSidYB8EeN/9dF4OqeQXU2rZ72f+ykWTvJIkq+7jLgeFvoOstceMib3mu4pQcXQq/SLm9TdnQkBUP6sN0e0511IsSk/7vfBKv3TLDmm9QYo0f26qI02wTVNQOv8577UmCVjaWgfAYBWNE5N8IfsmnAiAeeCFnhtrhoCovQnPbX9FFaiJVpUmAkRySu9E13V6ftr2Q+s9ovBTFtiOPCPTf5Nt8H3SSufSb7hZ2+HMRSWzOGXL76KWQMd9lNzjWg2HtlJhqc5W6R9ceRCXRyZgvBUl6u2g/DGqh/oAyYVYzIEKuI3deb342x8m+G3jb2nBhDwbDjuaENo47AgGoBE7mmfFv/Imh3bByDJEB9iXnZRQNdpABWMGO9XyzehOo5V+xYaWnZbWbFxvWWQFyDMCnGKqRngiF57ge0iaLW7cus9lu/zz6pkv4n+D2o
 QWzRINyJ
 vEFqs+bLQjXMeHdvYn7p6ZU1o565GfWilRqTT4UtKNwTVw4KRSyFdQu7hndxjb2dACJhJMNjGo5qFaSUoyUTQTz2VV4hwZevRdSvoIUnYJls7CfaGXSYaxOle4s2gHjCp3dpVeXlpJk9hS+ISlr9DPZh6A/AcpPmSNGTma5C9r+pK7n6gxiBxal7FAcs2hZPa68LH4MZloUfOTt2280VxbChzVJPuIakSj+xmY3RV6LN/5S7qavo8s3QWb5BNqDZ3YPZnRYtQpbmP5p3kjWCD+f6aRwIKSBv8DGmoNDe6YHEOe2nViJhkJ1EVZRsRUtqRcykuDcb0KWtT6co1WEVOujjD5luBkrnOhYzsu6MJmUztWFNhf+e2hRgcwnVSXOAJ4tz0bbp0NaDMyVhOy75ltJduq6VeK5v8KmDptQlcBsmmlos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 7:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sun, Apr 12, 2026 at 02:04:50PM +0800, Barry Song (Xiaomi) wrote:
> > Swap freeing can be expensive when unmapping a VMA containing
> > many swap entries. This has been reported to significantly
> > delay memory reclamation during Android=E2=80=99s low-memory killing,
> > especially when multiple processes are terminated to free
> > memory, with slot_free() accounting for more than 80% of
> > the total cost of freeing swap entries.
> >
> > Two earlier attempts by Lei and Zhiguo added a new thread in the mm cor=
e
> > to asynchronously collect and free swap entries [1][2], but the
> > design itself is fairly complex.
> >
> > When anon folios and swap entries are mixed within a
> > process, reclaiming anon folios from killed processes
> > helps return memory to the system as quickly as possible,
> > so that newly launched applications can satisfy their
> > memory demands. It is not ideal for swap freeing to block
> > anon folio freeing. On the other hand, swap freeing can
> > still return memory to the system, although at a slower
> > rate due to memory compression.
> >
> > Therefore, in zram, we introduce a GC worker to allow anon
> > folio freeing and slot_free to run in parallel, since
> > slot_free is performed asynchronously, maximizing the rate at
> > which memory is returned to the system.
> >
> > Xueyuan=E2=80=99s test on RK3588 shows that unmapping a 256MB swap-fill=
ed
> > VMA becomes 3.4=C3=97 faster when pinning tasks to CPU2, reducing the
> > execution time from 63,102,982 ns to 18,570,726 ns.
> >
> > A positive side effect is that async GC also slightly improves
> > do_swap_page() performance, as it no longer has to wait for
> > slot_free() to complete.
> >
> > Xueyuan=E2=80=99s test shows that swapping in 256MB of data (each page
> > filled with repeating patterns such as =E2=80=9C1024 one=E2=80=9D, =E2=
=80=9C1024 two=E2=80=9D,
> > =E2=80=9C1024 three=E2=80=9D, and =E2=80=9C1024 four=E2=80=9D) reduces =
execution time from
> > 1,358,133,886 ns to 1,104,315,986 ns, achieving a 1.22=C3=97 speedup.
> >
> > [1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.=
com/
> > [2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@viv=
o.com/
> >
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>
> Hi Barry
>
> This looks an interesting idea to me.
>
> > ---
> >  drivers/block/zram/zram_drv.c | 56 ++++++++++++++++++++++++++++++++++-
> >  drivers/block/zram/zram_drv.h |  3 ++
> >  2 files changed, 58 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> > index c2afd1c34f4a..f5c07eb997a8 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -1958,6 +1958,23 @@ static ssize_t debug_stat_show(struct device *de=
v,
> >       return ret;
> >  }
> >
> > +static void gc_slots_free(struct zram *zram)
> > +{
> > +     size_t num_pages =3D zram->disksize >> PAGE_SHIFT;
> > +     unsigned long index;
> > +
> > +     index =3D find_next_bit(zram->gc_map, num_pages, 0);
> > +     while (index < num_pages) {
> > +             if (slot_trylock(zram, index)) {
> > +                     if (test_bit(index, zram->gc_map))
> > +                             slot_free(zram, index);
> > +                     slot_unlock(zram, index);
> > +                     cond_resched();
> > +             }
> > +             index =3D find_next_bit(zram->gc_map, num_pages, index + =
1);
> > +     }
> > +}
> > +
>
> The ideas looks interesting but the implementation looks not that
> optimal to me. find_next_bit does a O(n) looks up for every gc call
> looks really expensive if the pending slot is at tail.

Agreed. It=E2=80=99s essentially a prototype at this stage to demonstrate t=
he
idea.

>
> Perhaps a percpu stack can be used, something like the folio batch?

I guess a major difference is that folio batching aims to reduce
lruvec lock contention. Once a CPU=E2=80=99s slot space is empty, it batche=
s
draining folios into the lruvec by checking whether some slots can
share the same lock. This procedure is synchronous within
folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);

In our case, we might not want a synchronous procedure, so each CPU
could launch its own workqueue. I=E2=80=99m not sure whether this is actual=
ly
beneficial, as it might trigger the zsmalloc lock contention we are
trying to eliminate.

If we end up wanting to drain all CPUs together, that would make things
quite complex again.

So I guess a hierarchical bitmap, an XArray, or even a simple array
could work. If we cap it at 64MB, the array would be at most 128KB on a
PAGE_SIZE=3D4KB system.

I am CC=E2=80=99ing Wenchao, who may be interested in further measurements
and also involved in a more efficient implementation.

>
> > -     slot_free(zram, index);
> > +     if (!try_slot_lazy_free(zram, index))
> > +             slot_free(zram, index);
>
> What is making this slot_free so costly? zs_free?
>
> >       slot_unlock(zram, index);
> >  }
> >
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_dr=
v.h
> > index 08d1774c15db..1f3ffd79fcb1 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -88,6 +88,7 @@ struct zram_stats {
> >       atomic64_t pages_stored;        /* no. of pages currently stored =
*/
> >       atomic_long_t max_used_pages;   /* no. of maximum pages stored */
> >       atomic64_t miss_free;           /* no. of missed free */
> > +     atomic64_t gc_slots;            /* no. of queued for lazy free by=
 gc */
>
> Maybe we want to track the size of content being delayed instead
> of slots number? I saw there is a 30000 hard limit for that.

Yep, definitely we want size, not number of pages, since PAGE_SIZE
is not constant.

>
> Perhaps it will make more sense if we have a "buffer size"
> (e.g. 64M), seems more intuitive to me. e.g. the ZRAM module can occupy
> at most 64M of memory, so the delayed free won't cause a significant
> global pressure.
>
> Also I think this patch is batching the memory free operations, so the
> workqueue or design can also be further optimized for batching, for
> example if the zs_free is the expensive part then maybe we shall just
> clear the handler for the freeing slot and leave the handler in a
> percpu stack, then batch free these handlers. zsmalloc might make
> use some batch optimization based on that too, something like
> kmem_cache_free_bulk but for zsmalloc?

I=E2=80=99m not really sure a per-CPU approach is the right direction, sinc=
e
zsmalloc already has a lot of contention we may want to eliminate. If
we introduce per-CPU workqueues or similar mechanisms, we might end up
increasing contention rather than reducing it.

A kmem_cache_free_bulk()-like approach might be a good direction to
investigate for zsmalloc. I guess Xueyuan is also thinking about it?
Right now, zsmalloc frequently takes and releases multiple locks for
each individual.

>
> if zs_free is not all the expensive part, I took a look at slot_free
> maybe a lot of read / write of slot data can be merged.
>
> This patch currently doesn't reduce the total amount of work, but
> if above idea works, a lot of redundant operations might be be dropped,
> result in better performance in every case.

Yep, hopefully we can optimize for every case. Of course, that will
take a lot of time :-)

>
> Just my two cents and ideas, not sure if I got everything correct.
> Looking forward for more disscussion on this :)

Thanks for your suggestions=E2=80=94they are always welcome. We may
discuss this further.

Best Regards
Barry

