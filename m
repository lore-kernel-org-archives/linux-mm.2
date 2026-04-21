Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FA7F94CA7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0498F6B0005; Tue, 21 Apr 2026 15:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023566B0089; Tue, 21 Apr 2026 15:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C3A6B008A; Tue, 21 Apr 2026 15:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D50CD6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:46:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8769EE63D4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:46:59 +0000 (UTC)
X-FDA: 84683596158.11.20518F6
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7455B40012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:46:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxFXZbQK;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776800817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKc+3XShNvSGAUkrOOm7vc1nfqz/ste7x65pdAa0N94=;
	b=jJaTV1PenVKnOkwIK5VvfY3m57qN6E+xQMi61N6cZQ49Fhab2jn4RIR6uagmUUMUYE6pcx
	EuvK4M3OBKiOj1NjLfTKC8XjO5nqGGzJ5Wpe0QLP4LLYI09jBFwpbxsL7Dc7DWp37NxBGH
	eMxlhv6u3gMute84zCkZ656QEbNCzTE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxFXZbQK;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776800817; a=rsa-sha256;
	cv=pass;
	b=1+6Eunyn13vY9l6gUSyP88y+yyY/wNmsZPYW4skseVZLd5KOzNq4gWOQKwSjotO/Escn2O
	r4eKJRTk1r3QBfu6gzmVxx9CvQeymqL2lCwig0dBPV+WzT19mnre5nlIInrhQ4jB4NipIO
	ukuLxOq/1B/b14Ld8nVK/l5jRooCI0g=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4411e1eba51so1324155f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776800816; cv=none;
        d=google.com; s=arc-20240605;
        b=dPmAoi3c1Kd3k7JqWqW06AJOykq0pWIoJLgQXopyvI9nA5kqZm9xwl1oxucZQI8YqK
         XJs2JKa+QLALOvI3IczFXfyh1WL57olvGxZ1eoKBWCJcbhEL2iNDlIIxH8lTMGk5Dgk+
         IvVn4ukOfc0CpNwhM9J8WiGw+ubHPF4u6nx8/pUOYL6HXrMHpsdn5XvbIIslycqG40Cw
         vNxiWu38fBe2gqTeJ/kEEBq1iHLzKTmHsbjuhPDXmxeaLCtpTw18Mulkia9ARX6KIGDr
         Te1Bj3AfVg9fVefbDuYZ40nCde1zO30k2imXzv5ux+8/fWEVZlcAFp3U/9qrCxFf/3H1
         UZMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LKc+3XShNvSGAUkrOOm7vc1nfqz/ste7x65pdAa0N94=;
        fh=JpE2HPi97g+Z0K8uo0HJ7h1Oyn5C75PKXon2XHb7QA0=;
        b=AJmDWc6Wg24YF7R4QfKO2cNC/nIWkXbjN9hJdOzPLDe9swR3e0jrxLzZHkjto/24KJ
         koefNPy8YRKCnxrVbeSHbVH00G5ck5F6Otjnvbq1VpRsgWnWeGsMjvOEtUMqkK3xiq/d
         F153IDd4PB3IrOON3ADZhjnOGGvfr4g23Us2o7viAdqFfSxshe9M2pyqTQUZn0W1Tx3U
         Pi7JA2T/8XtyqBF3GLMi2oCkHGhPJFToMxUlC6/+TUv5vPoKjXsp9mHXV2SZGcbOvjAz
         ThUYpfK8FgXwlAiXKewF8uD4hgv4WxQmBlU72lsHTQvoiSq4PHhwPRo8gUJpAvQjgo+l
         IgEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776800816; x=1777405616; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKc+3XShNvSGAUkrOOm7vc1nfqz/ste7x65pdAa0N94=;
        b=UxFXZbQKRzt24BlfPdMr0PCKTKJOEuFHc9jwleCDa6vC6YyUiCZfJEjsDhYTD7Dd69
         nzx5k7hkcjKeCC9eYwkdM48ZvBzenmKbQ/vol6yjEr1Rtaj+posnOJldSIhcuosvwqK9
         oDBo+EaEGGiKIzFQQhtwDTqa1WdX7T6n0fa9DYg+zXXj8aiR4yBhQyWy8JwuK4C90Bjh
         uh9Od26V6s0NJKwpFTnh1H4xzuOhuFD/BsFF/aBy1gpZxJsZPsbGYdDCoffULHA9aDwf
         0zHnHmEYsC7djSaqicJIILZvlnnW/LTLVER5HAiemHTAoR7X/FHFOpAbJCjb2dxUFM6m
         KuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776800816; x=1777405616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LKc+3XShNvSGAUkrOOm7vc1nfqz/ste7x65pdAa0N94=;
        b=TOwPkPd0TPfTS+fPyhsLrqkEeyAcdWbxRsvSULeO0kEt4jnPhg2qUdPuEfjM9VFVqk
         cH/BgA0N8q8aNVx99CREH1uvVXP+Oq3BADCg7FmAnsop3Cjten/E59FnK98jwZu2vxbQ
         ageKSv/NnOrr4gv10eBm8Ajfd2ulYbvs/n6hMX+aEjIXWGgTo0wSKf255v+TudfOcFWF
         O2qn/ZSgHyEtp+YOU+bOutRWj4YURUrb/k/rjyTUMnFP2CUzlyCu4K/GirAd0LiBSNpk
         0mw8czxJSEW8euSJO1fTEC664A90Kzfs6hsxzzgZH72SBYvjffC0j2ep0JjC4yjKdhhF
         HdZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9MPLZWw+qezja6SBBV9TsyE+isPrEJzIOxXVwR3EzFE11a7sr/dcCYbO5eWC3jfrtzx3dYwWvgCg==@kvack.org
X-Gm-Message-State: AOJu0YxSaNzD5JeC/SzcvHsMsKo5ujpfKs37bOoOLMczmomasYw/44ql
	/YvtJxTB0lZYc9OTt8tkCtNJ7eti4qIrGJUCMInCSBvU/4VRFahuB6JMlcCxdFb8dp89iDDDltl
	9CeYuu9+xKw+LNkS3ZWdTkI9XXveze0ALrVtC2uw=
X-Gm-Gg: AeBDietdEZCmNxkM+KU0OBCnWd7b8ZiSg8KjHY2v3nUi8R6LCHgja9G1K25NayMuebD
	3IdBcMBG9dVWNnvwU6cq+OoqVQ3j5+JdQNx2GXD9ypz3rgT5bXW4gistSCfyWXI2oymCqCnm/Xz
	HmnNyJrJS/7Pzaen7esoNOZTz0DP9wBn0FZQGIGKmDo1C6t2Q+LSXgFrvoNnYXrmKSlASxsNL+R
	2PVdZsDA+sV+Pspn4j8/0q+v+ucWlIs3GpBxYIA2mx5Wr77v5DK4Ue+5gY7MU9VjZiu9SN6JxN7
	qJokM5YpGNTdsU2+oeqGOJjJpcA5xFuOjTA+rQ7eIRDMKGcLfBzNKMKY/zhs/ICumA==
X-Received: by 2002:a05:6000:1acf:b0:43d:7946:bae6 with SMTP id
 ffacd0b85a97d-43fe3e236c2mr28724047f8f.43.1776800815609; Tue, 21 Apr 2026
 12:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com> <20260421121616.3298845-3-haowenchao@xiaomi.com>
In-Reply-To: <20260421121616.3298845-3-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Apr 2026 12:46:43 -0700
X-Gm-Features: AQROBzDBeKqAh3bxhbxh9vApl2qsd7P7xq3bhWanE7-5sQjVIdb4h2iu7McK_5k
Message-ID: <CAKEwX=P8_5qyou0KgvwvoPpRsUN4ohwsC7ysxjTW=Fbwk2uSOQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] mm/zsmalloc: introduce zs_free_deferred() for
 async handle freeing
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eudwztdnywxeywx18t5x8zpakdrkom9u
X-Rspamd-Queue-Id: 7455B40012
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776800817-404857
X-HE-Meta: U2FsdGVkX190ok7wUkS0HwRv6RfkIOoaEZ1E2psLyTcrHH8TRoIOabgQO+EXdCpINxzWdguXJj/KqYEfUSUeiM+OhJB8Epyd/m/VaUYgKOs8fS/jD5Bi1Qi6eI1qd1Ga1BqCrdIF8fdaAN8bCPn0pjHtHz9sd0iQr4/M9E9u/GKzp8fyI0OPG1r22PhooPJsPuAeOYM3LBFPEjKS70DbkD6Klv6EjMBMSJN+6nQCdEnKets4XDZwo73itI3+6QOENmrp3IRmHSW+wq853GQ7g0978dLap9cMwkXv3M1xoJMbnoUYaB3a627eFROW2mqUr2LuZhzgSpPOyIuedEXeU4HZjQ3nGPP79JUqeBL+P1MUnWl7ysI43L/f/YG8C2q6JUyQ+2EvHvbGQW5ymCQsMDzcLMzjElENF8qCI6+vmAVDqYraEQnafeTbZ6SATnvYJGqlbQ4VP6xFWRSxXLIAmycW50ABICR+qzDxC1HKXSAWP5J4GnQEGReyWkBxVU6LGQs+8NAiAmLPDYqyl7o1piH2mU3RpANcXupwE4XPCO7EpedQuedK94ht//tRth4+U1hFJR+oNqRQWpwRHnyA0R+l7ACn49zI/oVw0s41EiwCJIMa5NOzgViC2p/kcN9mQBxhZDqbqQ1OgBAbhOnHALlGdXKtoCKJvaiM//ZsNdTqq9YubGtWVFtp34gRTJPe9We4WpsaG1Qz0FS4lHIkdiVnEp3cfKZKke4PGi0h2NG63Ygi5I1n9NQ/btgfJ277BDI6HLEWTLJbUddiMVfYE5PlZ13tkvImeEkn9qxIiBo4P0dmWdV5FXjXnnvwtv9GtkwgE/vZ4LOX4TzhE4kKnq8Jkk5kG2lQFHgFYXgoA1IZMpHm0II0j2LvbASFrBWDKi9sv6Mue5gjZ0CfqwL2Je7D+ihQMngICKoa0MtQaw9isJMsIcPshvNV6XfffRnwZOcoY7aYbyyUvkPHrgl
 4R8uKha3
 hLWGQ3Keb8c9dumBwG8NUsXwLyfVkQ5tEgi+LDtqzk9ZrykL86h+A6Ix7L0hWwDaDk7ymJunHFWqmlvPKtceoHSbX24rSCvN5UnjBNlkLlvt8+OpJ/TaA4/YRSBhZGO6qWfVpmX06xslKmUd/J6gM66NaY5D9SQJicQsHm1j+99KZHrtmLnBOL7n6lAD0DlgenmhwbNWXEvH/Xgj97O9S5t3PHayeqTtmjjM6+1H/fm44RURFDnq+hEqJblr9iOQNT4VSAxx3qSZ07P5qRtiboT6SEyWP/3YGCGQqadYpHaTzJKH7JI9tXrJN9uBX1YinDSBwoqjVkIDDKTyu1q7TLGfIWcsh2A9VZJmO8o4u72ZCyv1oWPSnm0GCREv4Ag4o2btjxVoHnOPW+8uLZPl5xJ9SnTi12F1vCflq3Urdx1Vrw9NjCo5CGTVpO6bxRkkfOmBk2RvlDg9wA4gDDkUoSTnP4MclYCoP0Ui9lh9crKm6SaBRjhKVoslNxfCD2y03yotEm/ivs1vvXc/+E4KIV6ZCAGH7kD8B8p3tQD8En9WrD/ot57fQp7BtY/MYpS3TyzMp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> zs_free() is expensive due to internal locking (pool->lock, class->lock)
> and potential zspage freeing. On the process exit path, the slow
> zs_free() blocks memory reclamation, delaying overall memory release.
> This has been reported to significantly impact Android low-memory
> killing where slot_free() accounts for over 80% of the total swap
> entry freeing cost.
>
> Introduce zs_free_deferred() which queues handles into a fixed-size
> per-pool array for later processing by a workqueue. This allows callers
> to defer the expensive zs_free() and return quickly, so the process
> exit path can release memory faster. The array capacity is derived from
> a 128MB uncompressed data budget (128MB >> PAGE_SHIFT entries), which
> scales naturally with PAGE_SIZE. When the array reaches half capacity,
> the workqueue is scheduled to drain pending handles.
>
> zs_free_deferred() uses spin_trylock() to access the deferred queue.
> If the lock is contended (e.g. drain in progress) or the queue is full,
> it falls back to synchronous zs_free() to guarantee correctness.
>
> Also introduce zs_free_deferred_flush() for use during pool teardown to
> ensure all pending handles are freed.

Hmmm per-pool workqueue.

Does that mean that if you only have one zs pool (in the case of
zswap, or if you only have one zram device), you'll have less
concurrency in freeing up zsmalloc memory for process teardown? Would
this be problematic?

I think Kairui was also suggesting per-cpu-fying these batches/queues.

>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
>  include/linux/zsmalloc.h |   2 +
>  mm/zsmalloc.c            | 111 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+)
>
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 478410c880b1..1e5ac1a39d41 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -30,6 +30,8 @@ void zs_destroy_pool(struct zs_pool *pool);
>  unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
>                         const int nid);
>  void zs_free(struct zs_pool *pool, unsigned long obj);
> +void zs_free_deferred(struct zs_pool *pool, unsigned long handle);
> +void zs_free_deferred_flush(struct zs_pool *pool);
>
>  size_t zs_huge_class_size(struct zs_pool *pool);
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 40687c8a7469..defc892555e4 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -53,6 +53,10 @@
>
>  #define ZS_HANDLE_SIZE (sizeof(unsigned long))
>
> +#define ZS_DEFERRED_FREE_MAX_BYTES     (128 << 20)
> +#define ZS_DEFERRED_FREE_CAPACITY      (ZS_DEFERRED_FREE_MAX_BYTES >> PA=
GE_SHIFT)
> +#define ZS_DEFERRED_FREE_THRESHOLD     (ZS_DEFERRED_FREE_CAPACITY / 2)
> +
>  /*
>   * Object location (<PFN>, <obj_idx>) is encoded as
>   * a single (unsigned long) handle value.
> @@ -217,6 +221,13 @@ struct zs_pool {
>         /* protect zspage migration/compaction */
>         rwlock_t lock;
>         atomic_t compaction_in_progress;
> +
> +       /* deferred free support */
> +       spinlock_t deferred_lock;
> +       unsigned long *deferred_handles;
> +       unsigned int deferred_count;
> +       unsigned int deferred_capacity;
> +       struct work_struct deferred_free_work;
>  };
>
>  static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> @@ -579,6 +590,19 @@ static int zs_stats_size_show(struct seq_file *s, vo=
id *v)
>  }
>  DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
>
> +static int zs_stats_deferred_show(struct seq_file *s, void *v)
> +{
> +       struct zs_pool *pool =3D s->private;
> +
> +       spin_lock(&pool->deferred_lock);
> +       seq_printf(s, "pending: %u\n", pool->deferred_count);
> +       seq_printf(s, "capacity: %u\n", pool->deferred_capacity);
> +       spin_unlock(&pool->deferred_lock);
> +
> +       return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(zs_stats_deferred);
> +
>  static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
>  {
>         if (!zs_stat_root) {
> @@ -590,6 +614,9 @@ static void zs_pool_stat_create(struct zs_pool *pool,=
 const char *name)
>
>         debugfs_create_file("classes", S_IFREG | 0444, pool->stat_dentry,=
 pool,
>                             &zs_stats_size_fops);
> +       debugfs_create_file("deferred_free", S_IFREG | 0444,
> +                           pool->stat_dentry, pool,
> +                           &zs_stats_deferred_fops);
>  }
>
>  static void zs_pool_stat_destroy(struct zs_pool *pool)
> @@ -1432,6 +1459,76 @@ void zs_free(struct zs_pool *pool, unsigned long h=
andle)
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
>
> +static void zs_deferred_free_work(struct work_struct *work)
> +{
> +       struct zs_pool *pool =3D container_of(work, struct zs_pool,
> +                                           deferred_free_work);
> +       unsigned long handle;
> +
> +       while (1) {
> +               spin_lock(&pool->deferred_lock);
> +               if (pool->deferred_count =3D=3D 0) {
> +                       spin_unlock(&pool->deferred_lock);
> +                       break;
> +               }
> +               handle =3D pool->deferred_handles[--pool->deferred_count]=
;
> +               spin_unlock(&pool->deferred_lock);

Any reason why we're locking, grabbing a handle, then unlocking, one
at a time? Why dont we just lock, grab all the handles (or at least a
batch of them), unlock, then process the handles one at a time?

We can also have a pair of handle arrays. Whenever defer worker is
woken up, just swap the arrays under the lock, then free the handles
in the old array :)


> +
> +               zs_free(pool, handle);
> +               cond_resched();
> +       }
> +}
> +
> +/**
> + * zs_free_deferred - queue a handle for asynchronous freeing
> + * @pool: pool to free from
> + * @handle: handle to free
> + *
> + * Place @handle into a deferred free queue for later processing by a
> + * workqueue.  This is intended for callers that are in atomic context
> + * (e.g. under a spinlock) and cannot afford the cost of zs_free()
> + * directly.  When the queue reaches a threshold the work is scheduled.
> + * Falls back to synchronous zs_free() if the lock is contended (drain
> + * in progress) or if the queue is full.
> + */
> +void zs_free_deferred(struct zs_pool *pool, unsigned long handle)
> +{
> +       if (IS_ERR_OR_NULL((void *)handle))
> +               return;
> +
> +       if (!spin_trylock(&pool->deferred_lock))
> +               goto sync_free;
> +
> +       if (pool->deferred_count >=3D pool->deferred_capacity) {
> +               spin_unlock(&pool->deferred_lock);
> +               goto sync_free;
> +       }
> +
> +       pool->deferred_handles[pool->deferred_count++] =3D handle;
> +       if (pool->deferred_count >=3D ZS_DEFERRED_FREE_THRESHOLD)
> +               queue_work(system_wq, &pool->deferred_free_work);
> +       spin_unlock(&pool->deferred_lock);
> +       return;
> +
> +sync_free:
> +       zs_free(pool, handle);
> +}
> +EXPORT_SYMBOL_GPL(zs_free_deferred);
> +
> +/**
> + * zs_free_deferred_flush - flush all pending deferred frees
> + * @pool: pool to flush
> + *
> + * Wait for any scheduled work to complete, then drain any remaining
> + * handles.  Must be called from process context.
> + */
> +void zs_free_deferred_flush(struct zs_pool *pool)
> +{
> +       flush_work(&pool->deferred_free_work);
> +       zs_deferred_free_work(&pool->deferred_free_work);
> +}
> +EXPORT_SYMBOL_GPL(zs_free_deferred_flush);
> +
>  static void zs_object_copy(struct size_class *class, unsigned long dst,
>                                 unsigned long src)
>  {
> @@ -2099,6 +2196,18 @@ struct zs_pool *zs_create_pool(const char *name)
>         rwlock_init(&pool->lock);
>         atomic_set(&pool->compaction_in_progress, 0);
>
> +       spin_lock_init(&pool->deferred_lock);
> +       pool->deferred_capacity =3D ZS_DEFERRED_FREE_CAPACITY;
> +       pool->deferred_handles =3D kvmalloc_array(pool->deferred_capacity=
,
> +                                               sizeof(unsigned long),
> +                                               GFP_KERNEL);
> +       if (!pool->deferred_handles) {
> +               kfree(pool);
> +               return NULL;
> +       }
> +       pool->deferred_count =3D 0;
> +       INIT_WORK(&pool->deferred_free_work, zs_deferred_free_work);
> +
>         pool->name =3D kstrdup(name, GFP_KERNEL);
>         if (!pool->name)
>                 goto err;
> @@ -2201,6 +2310,7 @@ void zs_destroy_pool(struct zs_pool *pool)
>         int i;
>
>         zs_unregister_shrinker(pool);
> +       zs_free_deferred_flush(pool);
>         zs_flush_migration(pool);
>         zs_pool_stat_destroy(pool);
>
> @@ -2224,6 +2334,7 @@ void zs_destroy_pool(struct zs_pool *pool)
>                 kfree(class);
>         }
>
> +       kvfree(pool->deferred_handles);
>         kfree(pool->name);
>         kfree(pool);
>  }
> --
> 2.34.1
>

