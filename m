Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4604C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56ACE6B0092; Wed, 21 Jan 2026 15:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542576B0093; Wed, 21 Jan 2026 15:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445546B0095; Wed, 21 Jan 2026 15:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC916B0092
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:58:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7CAC8D555
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:58:42 +0000 (UTC)
X-FDA: 84357184884.10.D2A41D1
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4AE818000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:58:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lcs+aBRS;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769029120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MeTYXI3uAiRssw+rn1c1/h9gP0ELwUJeF0lPi9KAVw=;
	b=rvRxqHDxCSjJoJY2kgxvIniptO75yuOXyBGH/Njg0DUBT9KL9Kf7ty1YWSYQkfu7XA7hzF
	nS38kUK+LCzowJ0YA/obJ8mwwR+tplsvCGKaYp6Ym4Z5VvtnepGifXLqGOh5BSP6SU8oxM
	sUO1FbZhpNGTGFSY3SExZyTXjP2OF94=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lcs+aBRS;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769029120; a=rsa-sha256;
	cv=pass;
	b=i0JRMCdoRFIuGAc4ZjCqtORh9RvoBa+6A0mwuZkppsChwJzju8LSn125zZ+6SoN1YfXkr9
	B9s4kgMMNM4yl8liBm74kGS9SqV50Uj2Vn7Y5s1qpUtZyGWCB8gvKu4s5LSpfeUKTOGW4z
	FWvet27o5sJJo6Z4cX1nm/zqYESQjFQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50299648ae9so20831cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:58:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769029120; cv=none;
        d=google.com; s=arc-20240605;
        b=LQgbO9yHSd+6YX4iTSVQhXKXvffJ3irCOG557SUb89Ochi//NEm0Fp6oYtqBRH6DZu
         GgniysoQndYVuUprOlCy9/AOwx82tYdhCKvtvic4yvG9ItxZtgI9w8DV0J1FsQEyBW0C
         hXRteYLI1sZ9DA/OLeohPX7hD5wpT0tn0nCItpqch+W56wypNy/joP2PiQwAHHPUH9zs
         7LDJpw8RqX85MZOsgFLGwxXyCnoSlpRxNssN94/UItW8plYRcte+Ycspk44a2EmlCKWR
         fT9aKuhO4+pdmwoQdLbz0YI1eMsP+BqTQckEU0EGptroAmM3DVybguyalIDs/Q9+AtT+
         azSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9MeTYXI3uAiRssw+rn1c1/h9gP0ELwUJeF0lPi9KAVw=;
        fh=tsh/Ae+6kvYyAequ7pkYe0DMSjpqJVeGANUlfna5pms=;
        b=SXyaGMPOpR9QFQ5Ft4QBOQTbaUi4SIuXMS+IiDg93fovw0L+n2bjOlIRABkjWlBoY0
         Os6+M4hOf0Mld0bQnDVSXCrovFB4aWay2v/6c4Hi1Y2T1bGJ3SbU8cJTF/GzrggqgRBm
         GuxfRKIARqlmGM3+iu1nixPXrcRB4WFGg9BgBzZX+HT5KADU4NY/R9p16H5FugUm7mI7
         ip1rT6zgIcOOvikrIKmqe5W3bVx1vFAL7PeO8aOsssl4GcWPoK6Ja3ugk/iKQ3ZWOSfd
         YTKw3gNgNmHWwygaKmcu5w4WeZZT2YPtq2Pp8BHdfYSS235/j0nWq6gyERgGaf4eJXJ/
         9ZrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769029120; x=1769633920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MeTYXI3uAiRssw+rn1c1/h9gP0ELwUJeF0lPi9KAVw=;
        b=lcs+aBRSZ+BuLlX7OzuMBNIdDEe0PcW1Ly+zakUl+LpxZQFsVhCTvG/ptUFBkXxK+B
         fp4XAIkqPbojrK8kRFCRgGRu+JDLZojzpHBiLm52ifLzAabOv50dQUkR1VdoM2ZHkDe0
         CaBD0D9oqkTXpmqIMljL8kK+9mSzsdL30C5zDuHIuvTSQo3/yoAxhYCji6JHWnW5e32e
         6XIB4T5mtLOdXt20EYvdDfg2NPPda6uiWUgoaqD60yk70cOOsfvGodYQkS2EX6jzQmGj
         +d38YGiUYRWu7Hkp69t8ZHdDlrCtBcdT8VSRvpV/it8cgPJq4qiozKsrKZ06sEilVCuj
         noGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769029120; x=1769633920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9MeTYXI3uAiRssw+rn1c1/h9gP0ELwUJeF0lPi9KAVw=;
        b=qBbeDeHrKpc3+jx3KgeG/UmqLJoOrcADEilL2GgiR1excnrIvIA0BRtDjE40ZFcHtf
         7Cm6E8WZBK9Lcaa1/oUh+ra5kTpOPVTXbdJSytoiG3hlag+m4giaEkBmZE3McNYY0mRV
         0wu6dT9PlHRqS9imhLuLWaKJ0fIfMS2aIC29Hc8zjxEzb9Dgyk1LI6wPijvrBBL+BNfl
         OFZEJE2QqGzV5YL/n3zrRPthLGXRAxa9Xd3eeEgPBfC98mfFA/dRStGHtccGiqd7FCUy
         xQ/qk8qaaljtVs1yCkioyNnGot5oRDoc8c7fdICjB3L7S+EUWx8bs0MBJqMXcz8sE/hj
         rIuA==
X-Forwarded-Encrypted: i=1; AJvYcCV/XOpSPH7EzhXVSqvbykSSZaV/LIKoGxIrYe8GgpVOwG3loTaud671Ow/77Nv9bCWY3xeL41AqSA==@kvack.org
X-Gm-Message-State: AOJu0YylcgK1xa7nXy4cxjVauh8HYgG88vC6uLMiJ1Bq/rFgpwidWKQQ
	1gKocjsaw6nvLinIp315I6tGshWlviiKTWU8kjvn0t39bIYgUeCHFXBV2fbRa65r4jtNXbcKIYE
	aiLC0+QwS+MaJCpSPyL0Dd5oT+NC1FGDJ39VSOv7B
X-Gm-Gg: AZuq6aI8z+LGHlB3bZpOPQba1VNosB278WYbmSDuvrLbCby88TMuZ3CzBHjEkZWkkWy
	dj291rKwpU9+/suRBSjqggO8ipKn8RlRQO/TGEbKILFz7FAwhxXQdYmmcgD4qUFBmpvvo27LYxP
	eu6GCfcOhXPX3FZA77DikndzP75vw/bmWG/r4TqJY7NS2pqsqWyjVb4flDuhEoubqPaUtQbnpXu
	5CzKuv3s+4kcYqQY2dsZSmfMTgXCFwr6eSHwHi0kVQHB7HDc/P+XiQ+f2HOf9eJhOi6tUl8N/Ui
	6iYLJ+b6oa7lNSu8jYU4ekM=
X-Received: by 2002:ac8:7d13:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-502ebd66753mr2584691cf.14.1769029119662; Wed, 21 Jan 2026
 12:58:39 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 20:58:27 +0000
X-Gm-Features: AZwV_QgyZJFEnbtAO31t9RJqeLgp-_C0IEAaScaHgOZ1k_x7UdBOLV4hvrPmpf8
Message-ID: <CAJuCfpHZ5xJwg8uvK4XJ1+oBuNYQv3XMO8LHt9eEj_tJE=WkpA@mail.gmail.com>
Subject: Re: [PATCH v3 18/21] slab: update overview comments
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D4AE818000B
X-Stat-Signature: cg4wfhcf7z15k16cr5srymxhp6ge338s
X-Rspam-User: 
X-HE-Tag: 1769029120-972348
X-HE-Meta: U2FsdGVkX1/6xCCJfzgaB6h9cVdMArrZAKsItiHS3EeCF6rHb9k48KNZqYw3kz1uQBMtLNmuEpok1JnecHyqy1lULial+L2bF1OuEzu/8T5Db9Vt8LtMmx1ZbLY3DaXQncyeuP+Vorpr6eT2YAk0Sc4eniK2EJFnBqPJ52NTxWlfmP6b9vvctf0Vs8mTU7hyQYsklX3Rx/3uS4FqNV5lGG3GQRylVMdM58cAbUM3ddw2OubCGMFn4m+/1yK9DDXsZNyyfvHEFNOiS3uxTSa7TE+qic1fsh2jJqbiYxJoVDgOMCVmRqROVfkQXEomSJUceqDrKWZ+7QQyc8VyqzsSyQFA22Sl298LE8jOJczvzfhUHPmjG2sW9cpCUuxX2kzWuPeLxJGxOGN6UT7de0l+XODUxW8uXxQW/aMSZUeXL4wjp+VlcrtxMuuVO5eOzgKW1NmrLQAj2X04LaKeE3dl7DSgGxMmvv8l0EgrXiIsCsC9u1HT7lbRG1SHIOvaZ3TCnvyYFP7YADa4Ua5ygLh9FVrkebhK7Ol1+edqVIvMwQ23PiSPbXp6q6KqjwY7Yd7bUFCa8G2p2GG6/dM1oD282qeESwXfiTCCH+qVCB0Ef1F9RGob1Bm50X+jkm9UZG/YuHBOQtm+D3uCPShJdDYbDealzAjO/MBTiQsP8YxnRQlT4OhKJ0MVQxuYzzim/pboPPfcKf5597fvgE5zHQykBlE6TJtLhGcOSRUvysg2GZJISz/G0+rUspiQ+BBrjt8/WyeAxxu02IKmMmiWEqxBksRlNLnVm0EJutRr+NXs+30z4vXU2OhGrqjpHhdLuA3rO+ToxW0qyb/m82NNVJwCEMFRGDEvGZiaAN3k8i1dy3gslfu1euXpSnPmW273Ou8FxM/ac4ez5RUpww1Fjm/botk+fFAvuD2psw3K8U9EJFS4lXq/7aqd39Cx3J8Lmk1triepnGVnLxiPRupTjlR
 bpvnjz3T
 TV6XKQME2subhm6WktZOw0JYAShnsz0PPOWTg2UDd1nVJ9jwUC43hyISuhJzqzsj5ze+LEy1miu4Xq1imRH9/EBpo8PI7GhJ46+nZgmA2uyafFou46lLAcbMqMvZxQDAsQM3EYYb7niEzi+PIbRSeM4hvOiap18uUWBrGi6Q5y6f7mRyjcplsZ7xbKDak9Ukmud+d5mNG51LwEUqRHMlqzqaePvZOJ4CXsEEnd0ZgihyN8XAl64vPmar5Ka9T/liJiXjIcHfFHe/uZx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:41=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> The changes related to sheaves made the description of locking and other
> details outdated. Update it to reflect current state.
>
> Also add a new copyright line due to major changes.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 141 +++++++++++++++++++++++++++++---------------------------=
------
>  1 file changed, 67 insertions(+), 74 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 2c522d2bf547..476a279f1a94 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1,13 +1,15 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * SLUB: A slab allocator that limits cache line use instead of queuing
> - * objects in per cpu and per node lists.
> + * SLUB: A slab allocator with low overhead percpu array caches and most=
ly
> + * lockless freeing of objects to slabs in the slowpath.
>   *
> - * The allocator synchronizes using per slab locks or atomic operations
> - * and only uses a centralized lock to manage a pool of partial slabs.
> + * The allocator synchronizes using spin_trylock for percpu arrays in th=
e
> + * fastpath, and cmpxchg_double (or bit spinlock) for slowpath freeing.
> + * Uses a centralized lock to manage a pool of partial slabs.
>   *
>   * (C) 2007 SGI, Christoph Lameter
>   * (C) 2011 Linux Foundation, Christoph Lameter
> + * (C) 2025 SUSE, Vlastimil Babka
>   */
>
>  #include <linux/mm.h>
> @@ -53,11 +55,13 @@
>
>  /*
>   * Lock order:
> - *   1. slab_mutex (Global Mutex)
> - *   2. node->list_lock (Spinlock)
> - *   3. kmem_cache->cpu_slab->lock (Local lock)
> - *   4. slab_lock(slab) (Only on some arches)
> - *   5. object_map_lock (Only for debugging)
> + *   0.  cpu_hotplug_lock
> + *   1.  slab_mutex (Global Mutex)
> + *   2a. kmem_cache->cpu_sheaves->lock (Local trylock)
> + *   2b. node->barn->lock (Spinlock)
> + *   2c. node->list_lock (Spinlock)
> + *   3.  slab_lock(slab) (Only on some arches)
> + *   4.  object_map_lock (Only for debugging)
>   *
>   *   slab_mutex
>   *
> @@ -78,31 +82,38 @@
>   *     C. slab->objects        -> Number of objects in slab
>   *     D. slab->frozen         -> frozen state
>   *
> - *   Frozen slabs
> + *   SL_partial slabs
> + *
> + *   Slabs on node partial list have at least one free object. A limited=
 number
> + *   of slabs on the list can be fully free (slab->inuse =3D=3D 0), unti=
l we start
> + *   discarding them. These slabs are marked with SL_partial, and the fl=
ag is
> + *   cleared while removing them, usually to grab their freelist afterwa=
rds.
> + *   This clearing also exempts them from list management. Please see
> + *   __slab_free() for more details.
>   *
> - *   If a slab is frozen then it is exempt from list management. It is
> - *   the cpu slab which is actively allocated from by the processor that
> - *   froze it and it is not on any list. The processor that froze the
> - *   slab is the one who can perform list operations on the slab. Other
> - *   processors may put objects onto the freelist but the processor that
> - *   froze the slab is the only one that can retrieve the objects from t=
he
> - *   slab's freelist.
> + *   Full slabs
>   *
> - *   CPU partial slabs
> + *   For caches without debugging enabled, full slabs (slab->inuse =3D=
=3D
> + *   slab->objects and slab->freelist =3D=3D NULL) are not placed on any=
 list.
> + *   The __slab_free() freeing the first object from such a slab will pl=
ace
> + *   it on the partial list. Caches with debugging enabled place such sl=
ab
> + *   on the full list and use different allocation and freeing paths.
> + *
> + *   Frozen slabs
>   *
> - *   The partially empty slabs cached on the CPU partial list are used
> - *   for performance reasons, which speeds up the allocation process.
> - *   These slabs are not frozen, but are also exempt from list managemen=
t,
> - *   by clearing the SL_partial flag when moving out of the node
> - *   partial list. Please see __slab_free() for more details.
> + *   If a slab is frozen then it is exempt from list management. It is u=
sed to
> + *   indicate a slab that has failed consistency checks and thus cannot =
be
> + *   allocated from anymore - it is also marked as full. Any previously
> + *   allocated objects will be simply leaked upon freeing instead of att=
empting
> + *   to modify the potentially corrupted freelist and metadata.
>   *
>   *   To sum up, the current scheme is:
> - *   - node partial slab: SL_partial && !frozen
> - *   - cpu partial slab: !SL_partial && !frozen
> - *   - cpu slab: !SL_partial && frozen
> - *   - full slab: !SL_partial && !frozen
> + *   - node partial slab:            SL_partial && !full && !frozen
> + *   - taken off partial list:      !SL_partial && !full && !frozen
> + *   - full slab, not on any list:  !SL_partial &&  full && !frozen
> + *   - frozen due to inconsistency: !SL_partial &&  full &&  frozen
>   *
> - *   list_lock
> + *   node->list_lock (spinlock)
>   *
>   *   The list_lock protects the partial and full list on each node and
>   *   the partial slab counter. If taken then no new slabs may be added o=
r
> @@ -112,47 +123,46 @@
>   *
>   *   The list_lock is a centralized lock and thus we avoid taking it as
>   *   much as possible. As long as SLUB does not have to handle partial
> - *   slabs, operations can continue without any centralized lock. F.e.
> - *   allocating a long series of objects that fill up slabs does not req=
uire
> - *   the list lock.
> + *   slabs, operations can continue without any centralized lock.
>   *
>   *   For debug caches, all allocations are forced to go through a list_l=
ock
>   *   protected region to serialize against concurrent validation.
>   *
> - *   cpu_slab->lock local lock
> + *   cpu_sheaves->lock (local_trylock)
>   *
> - *   This locks protect slowpath manipulation of all kmem_cache_cpu fiel=
ds
> - *   except the stat counters. This is a percpu structure manipulated on=
ly by
> - *   the local cpu, so the lock protects against being preempted or inte=
rrupted
> - *   by an irq. Fast path operations rely on lockless operations instead=
.
> + *   This lock protects fastpath operations on the percpu sheaves. On !R=
T it
> + *   only disables preemption and does no atomic operations. As long as =
the main
> + *   or spare sheaf can handle the allocation or free, there is no other
> + *   overhead.
>   *
> - *   On PREEMPT_RT, the local lock neither disables interrupts nor preem=
ption
> - *   which means the lockless fastpath cannot be used as it might interf=
ere with
> - *   an in-progress slow path operations. In this case the local lock is=
 always
> - *   taken but it still utilizes the freelist for the common operations.
> + *   node->barn->lock (spinlock)
>   *
> - *   lockless fastpaths
> + *   This lock protects the operations on per-NUMA-node barn. It can qui=
ckly
> + *   serve an empty or full sheaf if available, and avoid more expensive=
 refill
> + *   or flush operation.
>   *
> - *   The fast path allocation (slab_alloc_node()) and freeing (do_slab_f=
ree())
> - *   are fully lockless when satisfied from the percpu slab (and when
> - *   cmpxchg_double is possible to use, otherwise slab_lock is taken).
> - *   They also don't disable preemption or migration or irqs. They rely =
on
> - *   the transaction id (tid) field to detect being preempted or moved t=
o
> - *   another cpu.
> + *   Lockless freeing
> + *
> + *   Objects may have to be freed to their slabs when they are from a re=
mote
> + *   node (where we want to avoid filling local sheaves with remote obje=
cts)
> + *   or when there are too many full sheaves. On architectures supportin=
g
> + *   cmpxchg_double this is done by a lockless update of slab's freelist=
 and
> + *   counters, otherwise slab_lock is taken. This only needs to take the
> + *   list_lock if it's a first free to a full slab, or when there are to=
o many
> + *   fully free slabs and some need to be discarded.
>   *
>   *   irq, preemption, migration considerations
>   *
> - *   Interrupts are disabled as part of list_lock or local_lock operatio=
ns, or
> + *   Interrupts are disabled as part of list_lock or barn lock operation=
s, or
>   *   around the slab_lock operation, in order to make the slab allocator=
 safe
>   *   to use in the context of an irq.
> + *   Preemption is disabled as part of local_trylock operations.
> + *   kmalloc_nolock() and kfree_nolock() are safe in NMI context but see
> + *   their limitations.
>   *
> - *   In addition, preemption (or migration on PREEMPT_RT) is disabled in=
 the
> - *   allocation slowpath, bulk allocation, and put_cpu_partial(), so tha=
t the
> - *   local cpu doesn't change in the process and e.g. the kmem_cache_cpu=
 pointer
> - *   doesn't have to be revalidated in each section protected by the loc=
al lock.
> - *
> - * SLUB assigns one slab for allocation to each processor.
> - * Allocations only occur from these slabs called cpu slabs.
> + * SLUB assigns two object arrays called sheaves for caching allocation =
and

s/allocation/allocations

> + * frees on each cpu, with a NUMA node shared barn for balancing between=
 cpus.
> + * Allocations and frees are primarily served from these sheaves.
>   *
>   * Slabs with free elements are kept on a partial list and during regula=
r
>   * operations no list for full slabs is used. If an object in a full sla=
b is
> @@ -160,25 +170,8 @@
>   * We track full slabs for debugging purposes though because otherwise w=
e
>   * cannot scan all objects.
>   *
> - * Slabs are freed when they become empty. Teardown and setup is
> - * minimal so we rely on the page allocators per cpu caches for
> - * fast frees and allocs.
> - *
> - * slab->frozen                The slab is frozen and exempt from list p=
rocessing.
> - *                     This means that the slab is dedicated to a purpos=
e
> - *                     such as satisfying allocations for a specific
> - *                     processor. Objects may be freed in the slab while
> - *                     it is frozen but slab_free will then skip the usu=
al
> - *                     list operations. It is up to the processor holdin=
g
> - *                     the slab to integrate the slab into the slab list=
s
> - *                     when the slab is no longer needed.
> - *
> - *                     One use of this flag is to mark slabs that are
> - *                     used for allocations. Then such a slab becomes a =
cpu
> - *                     slab. The cpu slab may be equipped with an additi=
onal
> - *                     freelist that allows lockless access to
> - *                     free objects in addition to the regular freelist
> - *                     that requires the slab lock.
> + * Slabs are freed when they become empty. Teardown and setup is minimal=
 so we
> + * rely on the page allocators per cpu caches for fast frees and allocs.
>   *
>   * SLAB_DEBUG_FLAGS    Slab requires special handling due to debug
>   *                     options set. This moves slab handling out of
>
> --
> 2.52.0
>

