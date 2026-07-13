Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9CCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6001E6B0005; Mon, 13 Jul 2026 13:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6A66B00A9; Mon, 13 Jul 2026 13:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4784C6B00B0; Mon, 13 Jul 2026 13:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00FF66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:09:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83BC1A0025
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:09:08 +0000 (UTC)
X-FDA: 84984388776.03.5A59785
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B5531C000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:09:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fOrD6ofz;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMQD9ms3qPqaBjOejdG/Wf1cfJSzUUmtubyo0yc1k48=;
	b=Jh8nqSSnQRYRWpfj4Kwuyj75RWRa+mWAIHk9AMS6J9IsmvXQxUwPYHuA04VEwAR+K4MnD3
	hyXbOFTCrl/ApgfKOrQe5MbYU+z4v0iVoqLGq46yX5qWDZMr3tX8f2cYpUCZ3CNexTrpZJ
	rKPDBoOoCTbZhoSz4Nf/ahEy7JXqt0o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783962546;
	b=UdDSJs28tXNUlOBfSR+rA/fAabdhb6zrj/JeoOE6Iev3HfOdPqZBI/d2bqwVgdgZ46LY/h
	R4PGpIqAjVaKvJGqKBXnS5GibP6VO3r38eWdS0OelPEEoOalz4TBmPlt8cUIcCIzVmBjfY
	0fr+txn9i+rKY5Nwn/qdxpKalTUpwek=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fOrD6ofz;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c01c79467so15121cf.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783962546; cv=none;
        d=google.com; s=arc-20260327;
        b=mJc9OpABimlplmD2G5SrnqcFZPaosgH780N4nWy+tjFW5nmI0NFIQtwc31d39f92ER
         WH4HUP3nJVf0bLd2qSbLTeyCabT0PtZRz8D7Hbz+EA0e4ZRVd1zDLIGTwJNneh7i4dum
         RzeDrYrxu7Ibx8YRCwYNuzily3IW+iCYIZmqwiTjXAczLUfSMmrldlpL5VUOBC1mnS1p
         9U2cMWAnhng/VAuhQ84lZ5sisJ/1/q6I0wCKXjNC+wula/f49TtV5ijvjLAjC6ypNMv9
         w7OzsT1q5s/aTWM8ux79emSZf1y+3zx0RV9OWR9JmrCusz2kdYh8aYxz0AaZ54oiu/Dr
         /E9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RMQD9ms3qPqaBjOejdG/Wf1cfJSzUUmtubyo0yc1k48=;
        fh=Zgta4X8mpdVXB7QemblOzl9vcNM8O8fwqz0ug+pZXZA=;
        b=cpfywZeVNAqJB7UF+AqgjGks8L9jbkHVbJ/mGELRvNhNciT7siNk8WHcy9onetwFa0
         NB1Mfp2j3dHIDCzabZQ+iVRKZnnICvJifaacZk7EecTCZxzI08JJ63IoEWHIN3Qtt1iA
         hEpqOK9x+2kbMt+qmZiBbJBjR2ZyRmjUN/eiTQb7GvnXuTFhWMU9oQ2b1omPzJtyrz9X
         +cjyRJhBS6rLwCBZ54DGZrF4ETLII+Zvnic7GyXH8Y6ixYmekLJGd12BmrdUFzim5MZn
         Ft2MlBpWXxC+fO6g0yFJ8+QUjzpOaKNBdMDz8lbTPh8NNYtq3+Z9lQ2wXUftSjpPUFT5
         P9WA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783962546; x=1784567346; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RMQD9ms3qPqaBjOejdG/Wf1cfJSzUUmtubyo0yc1k48=;
        b=fOrD6ofz//miPe2cmX2vrh2cVmHwtMUtsK5sVXIET3XoWLfu/W+82FhGznAwDDGX2J
         +PtjSkoXmATkkvvc/TT3gBM5nhyPRZSrYNdAkFWz/nB+3rbEbRWm1armpKSGTIdqQExc
         GjwnLkumYErWLWAKkP/fauXLXJejTMSKDsif2EKZUsW7KhCBh33ogFRifIoXxdlauCpd
         VXuYHfP12C2ll7GZY4UHT9aeeqUyvDQ21cRFpIa1W8mTFDtlEYqayzoAqnm5t6ceVOZ7
         T3T2LFE107gGk5UtKm2cTT71jfMfT/kv9T5zlfLTZlw/Wlw3rmhmqmxKOf7dXH8IDnZo
         WqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962546; x=1784567346;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMQD9ms3qPqaBjOejdG/Wf1cfJSzUUmtubyo0yc1k48=;
        b=jE+XY8Mt18EORR4aKbc4eECqFKUnAk4rOWr+Y4BVJsnmZ+h7q/UYC7h3OYbcfkAPEb
         dClgkX9HP0ZuUDNLe5JXs1b1aYbDI9l032/lnnWcb3sx1gKviZLU2yWGTHFFCfOru+EX
         lx3dWOnb7POSPlWtvHRs5ArKaQ8xbKe/8b0krrXPz0MfcFWVpJRaMH+nYMZUROtH4Wmg
         wX7PKqFLsNKXurvbfcLhn5/Od2rjsv6HP1S6p2d242f+D81rSNxyZUQIsqWfBjqeBard
         UwcZKHT3/lwuSW6k1UloLJ+m2jV6Hy0lBW/2wuYxnCL99jGHztAK8p31pPFwKrdiHU1o
         PbeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpiQBMiSaxlxZXQ6Fe5cyPm13ZBvuyt6h+iNlWJuQ/pJm4WjZlBuOYszf9JLgR+Xi+erY4U6bBTbQ==@kvack.org
X-Gm-Message-State: AOJu0YwxKUldfCVezj2vHTtvpspMbyBYlm/16hHxTmC8p4vrqPgAwnYL
	9Zf/VfgJZN1cm/Yu8W2vXoa5YL+DSwLxGgCKpW7eXmE1TuIu0jWsIpha0+UQGx72DQadV2Iw4FF
	nThKtJNlRbNTt+puMWh0ej2LtDfpTqLHAb7kewFHI
X-Gm-Gg: AfdE7cnXcKD7heMSLoPTauzSN4UeXrivFdCIyXxVhrhGFn/8wn46DrnsLSlRT+I6p/8
	V4rpVHlg1+AyVbgSBR/vMdzsT8S19mCf7sPMLY1UHbV+kU6orytyJx6yf4ZNsr6YKze16Ampjoc
	jbDm8IhQiN3WjYe17rCX977k2rod1NPC7I733k7JAdy1m2eZjiQx0InNrwJiZ4t2REqYNc9/paz
	ZFM2vWi33UwZbrSDDNUIGZE9AikrXLoWVGSjlE+AkRp907L56SjR0OcpzOZ9tV1HigzhpCpMxEx
	Pl5dXieWVaZpkZoh
X-Received: by 2002:a05:622a:5c12:b0:51c:7a8b:c3ff with SMTP id
 d75a77b69052e-51d7bdb83edmr4317691cf.24.1783962544850; Mon, 13 Jul 2026
 10:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org> <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 10:08:51 -0700
X-Gm-Features: AUfX_mxjbOhg3eMKTZfNng1w5D5tFCOUs5dU1dbztWRbCnk4N-dnvX3KAvkPGB8
Message-ID: <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>
Subject: Re: [PATCH slab/for-next-fixes v3 4/4] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B5531C000B
X-Stat-Signature: gax1198osp4yqq1qkixq9bstd8xzh8ti
X-HE-Tag: 1783962546-101221
X-HE-Meta: U2FsdGVkX1/AL00T38BHDZLgD+DvzWMhbx6N6l8L4/I1uFBdzbCVTng6+qd5CBWWXlVjTimhv65am3WaKaz04R1IU/K/9XYSIO1orlj36dXix/C7WQ+g9YPJS6rr6GN+0Agd78Xbs9VytN7JRbA+MvWO1+OT4a302lp0+cJRoPmRTIReCy16dtjGQNGx5E9ymq8tAodyGAghI9PgN9qPySzIyLc3u27lxApVPLhekEG81zY3tTku8hYy48pmzXksCgwc+1WUfstX4HrDr5Ld4F23k1Dp+fOVBruhgidx7xso66kRc3eFR0Cj/siaZE4OKP8198etLA8zkY24tVO+bq4+FGG9rEeYSo/3qhKJCGGD0UBWUpjLU15zmEV/wPmkM6Q5s2UKVB1S4qt1qQ034bpIuFeJS3grjV/ydjOWGXUi81yHnt6nvJsaoV0CYDb3YxiVCEa0ttJn9UKIcu5GTp5tPe7g/NmScrMht1A1aTLFRwkbQ2J6MefStbF+7UXifiL16uLDDRaT2uzE1BT2/oOjjGXm6gyqAsY9wjG1aE39jjISBN2zGbWszOhLJ7hk7aI4D+qOGinmB2QoEiCLa+xuR0VPOFHHF2x8+Z/kKl2PFTQSrnK5uyrT/3SK0N0LBOUbLk9bcPYYPGec1P47SDWe7amKFmUivqc/AKStGQmoeK40zCAt0vvNyhsLs3TQhS3gECo2IAq1Z+rQoBtKJvuRxmQ8eysqUH+yGpvfaOK6k6X4LdJ7zFhvFjbPnyyCEEukc1vpnusOw2UmQbtKijWTDejbB+aba2ul3V3j3QbCkmh3wpF81bk6mPSYtRh53fZErgdm7QxZEPMQg7k0JCi+cnrxEiLh69JcyzBPNYUAOIEaxQW73RrhEe2wm+ja0zwi5x8ui92YL63pt4fhwxaXrvz5/qbDQe3TUpXQ9+ceVFKfjWaAxlkTPPUOzLVF9BBp5s72RawUwFmLoi9
 7nQcoP8I
 0Afq0qs6OztvcI2drLPvRg3qXuVhCPpTSqo0Y3pQZa0Qij0n8oM9a8JI3y6a3UZDGTAhFi28zK6qY4PWZFDLWQQ04Ei/A8VNli7M4mxwtyiXnAS9rbvWvZOQc53zwROldE8ZHHx5EV6yjU8Qh4oiA4ce9TD0YMgDhB6AgbHyPTx+2K/H1soymSv/MnJk118S4k+DWwrd9KdOW+K7Rzaq6zPqOaqf8iEiz4fSDEs7aM1M8aUynJLMV0yUkHdjqgeOuzrDJu8U+0p+K5U0qC6jEKX/T/UbduKJNhJK9h+DXwNhBg+cwp6Nn6tp8Rk84OSFqdbRS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> Commit 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from
> its own slab") avoided recursive allocation of obj_exts from kmalloc
> caches of the same size, by bumping the obj_exts array's allocation
> size whenever the array size equals the size of the object being
> allocated.
>
> However, as reported by Danielle Costantino and Shakeel Butt,
> even slabs from kmalloc caches of different sizes can form a cycle
> by allocating obj_exts arrays from each other [1]:
>
>   What happened: a KMALLOC_NORMAL slab's obj_exts array (used by
>   allocation profiling / memcg accounting) is itself kmalloc()'d from a
>   KMALLOC_NORMAL cache, so the "slab holds another slab's obj_exts array"
>   relation can form cycles. With sizeof(struct slabobj_ext) =3D=3D 16 and
>   the host's geometry:
>
>   - kmalloc-512 has 64 objects/slab -> array is 64*16 =3D=3D 1024 bytes,
>     served from kmalloc-1k;
>   - kmalloc-1k  has 32 objects/slab -> array is 32*16 =3D=3D  512 bytes,
>     served from kmalloc-512.
>
>   A kmalloc-512 slab and a kmalloc-1k slab therefore hold each other's
>   obj_exts array.  Discarding one frees the other's array, which empties
>   and discards that slab, which frees the first's array, and so on:
>   __free_slab() -> free_slab_obj_exts() -> kfree() -> discard_slab() ->
>   __free_slab() recurses along the cycle until the stack is exhausted.
>
> With memory allocation profiling, this allows unbounded recursion
> in the free path and led to a stack overflow on a production host in
> the Meta fleet [1]:
>
>   BUG: TASK stack guard page was hit
>   Oops: stack guard page
>   RIP: 0010:kfree+0x8/0x5d0
>   Call Trace:
>    __free_slab+0x66/0xc0
>    kfree+0x3f0/0x5d0
>    ... ( ~125x __free_slab <-> kfree ) ...
>    <kernel driver freeing a resource>
>    do_syscall_64
>
> It is proposed [1] to resolve this issue by always serving the obj_exts
> array allocation from kmalloc caches (or large kmalloc) of sizes larger
> than the object size. However, as pointed out by Vlastimil Babka [2],
> this can waste an excessive amount of memory as slabs from large
> kmalloc sizes (e.g. kmalloc-8k) generally need obj_exts arrays much
> smaller than the object size.
>
> Therefore, rather than bumping the size, let us take a different
> approach; disallow formation of cycles between kmalloc types when
> allocating obj_exts arrays. Currently, all obj_exts arrays are served
> from normal kmalloc caches. Cycles cannot be created if obj_exts arrays
> of normal kmalloc caches are served from a special kmalloc type that can
> never have obj_exts arrays.
>
> To achieve this, create a new kmalloc type called KMALLOC_NO_OBJ_EXT.
> KMALLOC_NO_OBJ_EXT caches are created with SLAB_NO_OBJ_EXT flag when
> either 1) memory allocation profiling is not permanently disabled,
> or 2) kmalloc types with a priority higher than KMALLOC_CGROUP are
> aliased with KMALLOC_NORMAL.
>
> Sheaf bootstrapping for KMALLOC_NO_OBJ_EXT caches now must be deferred
> because allocation of a barn can trigger obj_exts array allocation of
> normal kmalloc caches when the KMALLOC_NO_OBJ_EXT cache for that size
> is not ready yet. For simplicity, perform bootstrapping of sheaves for
> all kmalloc caches later.
>
> Introduce a new slab alloc flag, SLAB_ALLOC_NO_OBJ_EXT, to prevent
> allocation of obj_exts arrays, and let kmalloc_slab() override the type
> to KMALLOC_NO_OBJ_EXT when specified. Note that kmalloc_type() remains
> unchanged because kmalloc_flags() bypasses the kmalloc fastpath.
>
> Do not pass SLAB_ALLOC_NO_RECURSE to kmalloc_flags() in
> alloc_slab_obj_exts() and instead use SLAB_ALLOC_NO_OBJ_EXT only when
> the objects are allocated from normal kmalloc caches. While this
> prevents unbounded recursive allocation of obj_exts, it allows
> KMALLOC_NO_OBJ_EXT caches to have sheaves.
>
> Since sheaf allocations specify SLAB_ALLOC_NO_RECURSE that prevents
> allocation of both sheaves and obj_exts arrays, the recursion depth
> is bounded.
>
> obj_exts arrays for non-kmalloc-normal caches can now have a valid tag.
> Do not call mark_obj_codetag_empty() when freeing an obj_exts array to
> avoid false warnings. KMALLOC_NO_OBJ_EXT don't need this as they never
> allocate those arrays.
>
> Reported-by: Danielle Costantino <dcostantino@meta.com>
> Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/20260625230029.703750-1-shakeel.=
butt@linux.dev [1]
> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab alloca=
tion and free paths")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mm/c5c4208d-a6f0-413e-bad9-49be12f12d=
55@kernel.org [2]
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  include/linux/slab.h |  6 ++++
>  mm/slab.h            | 32 ++++++++++++++++--
>  mm/slab_common.c     | 19 ++++++++++-
>  mm/slub.c            | 92 +++++++++++++++++++---------------------------=
------
>  4 files changed, 87 insertions(+), 62 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 08d7b6c9c4d6..3a14df50766a 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -708,6 +708,9 @@ enum kmalloc_cache_type {
>  #endif
>  #ifndef CONFIG_MEMCG
>         KMALLOC_CGROUP =3D KMALLOC_NORMAL,
> +#endif
> +#ifndef CONFIG_SLAB_OBJ_EXT
> +       KMALLOC_NO_OBJ_EXT =3D KMALLOC_NORMAL,
>  #endif
>         KMALLOC_PARTITION_START =3D KMALLOC_NORMAL,
>         KMALLOC_PARTITION_END =3D KMALLOC_PARTITION_START + KMALLOC_PARTI=
TION_CACHES_NR,
> @@ -721,6 +724,9 @@ enum kmalloc_cache_type {
>  #endif
>  #ifdef CONFIG_MEMCG
>         KMALLOC_CGROUP,
> +#endif
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +       KMALLOC_NO_OBJ_EXT,
>  #endif
>         NR_KMALLOC_TYPES
>  };
> diff --git a/mm/slab.h b/mm/slab.h
> index 281a65233795..f5e336b6b6b0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -22,6 +22,7 @@
>  #define SLAB_ALLOC_NOLOCK      0x01 /* a kmalloc_nolock() allocation */
>  #define SLAB_ALLOC_NEW_SLAB    0x02 /* a flag for alloc_slab_obj_exts() =
*/
>  #define SLAB_ALLOC_NO_RECURSE  0x04 /* prevent kmalloc() recursion */
> +#define SLAB_ALLOC_NO_OBJ_EXT  0x08 /* prevent obj_exts array allocation=
 */
>
>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_f=
lags)
>  {
> @@ -386,12 +387,17 @@ static inline unsigned int size_index_elem(unsigned=
 int bytes)
>   * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
>   */
>  static inline struct kmem_cache *
> -kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t =
token)
> +kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t =
token,
> +            unsigned int alloc_flags)
>  {
>         unsigned int index;
> +       enum kmalloc_cache_type type =3D kmalloc_type(flags, token);
> +
> +       if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
> +               type =3D KMALLOC_NO_OBJ_EXT;

Why not let kmalloc_type() handle alloc_flags? Other users (there are
only 4 of them) can pass SLAB_ALLOC_DEFAULT. That seems cleaner to me
and more robust.

>
>         if (!b)
> -               b =3D &kmalloc_caches[kmalloc_type(flags, token)];
> +               b =3D &kmalloc_caches[type];
>         if (size <=3D 192)
>                 index =3D kmalloc_size_index[size_index_elem(size)];
>         else
> @@ -426,7 +432,8 @@ static inline bool is_kmalloc_normal(struct kmem_cach=
e *s)
>  {
>         if (!is_kmalloc_cache(s))
>                 return false;
> -       return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACC=
OUNT));
> +
> +       return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACC=
OUNT|SLAB_NO_OBJ_EXT));
>  }
>
>  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> @@ -529,6 +536,25 @@ static inline void metadata_access_disable(void)
>         kasan_enable_current();
>  }
>
> +/*
> + * Return true if KMALLOC_NORMAL caches may need obj_exts arrays.
> + *
> + * Memory allocation profiling requires obj_exts for all caches.
> + * Memcg usually doesn't need them for normal kmalloc caches, but kmallo=
c types
> + * with a priority higher than KMALLOC_CGROUP can be aliased with KMALLO=
C_NORMAL.
> + */
> +static inline bool need_kmalloc_no_objext(void)
> +{
> +       if (!mem_alloc_profiling_permanently_disabled())
> +               return true;
> +
> +       if (!mem_cgroup_kmem_disabled() &&
> +                       (KMALLOC_NORMAL =3D=3D KMALLOC_RECLAIM))
> +               return true;
> +
> +       return false;
> +}
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>
>  /*
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b6426d7ceec9..03ecac12cd86 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -783,11 +783,15 @@ u8 kmalloc_size_index[24] __ro_after_init =3D {
>  size_t kmalloc_size_roundup(size_t size)
>  {
>         if (size && size <=3D KMALLOC_MAX_CACHE_SIZE) {
> +               struct kmem_cache *s;
> +
>                 /*
>                  * The flags don't matter since size_index is common to a=
ll.
>                  * Neither does the caller for just getting ->object_size=
.
>                  */
> -               return kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_tok=
en(0))->object_size;
> +               s =3D kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_toke=
n(0),
> +                                SLAB_ALLOC_DEFAULT);
> +               return s->object_size;
>         }
>
>         /* Above the smaller buckets, size is a multiple of page size. */
> @@ -843,6 +847,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  #define KMALLOC_PARTITION_NAME(N, sz)
>  #endif
>
> +#ifdef CONFIG_SLAB_OBJ_EXT
> +#define KMALLOC_NO_OBJ_EXT_NAME(sz) .name[KMALLOC_NO_OBJ_EXT] =3D "kmall=
oc-no-objext-" #sz,
> +#else
> +#define KMALLOC_NO_OBJ_EXT_NAME(sz)
> +#endif
> +
>  #define INIT_KMALLOC_INFO(__size, __short_size)                        \
>  {                                                              \
>         .name[KMALLOC_NORMAL]  =3D "kmalloc-" #__short_size,      \
> @@ -850,6 +860,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>         KMALLOC_CGROUP_NAME(__short_size)                       \
>         KMALLOC_DMA_NAME(__short_size)                          \
>         KMALLOC_PARTITION_NAME(KMALLOC_PARTITION_CACHES_NR, __short_size)=
       \
> +       KMALLOC_NO_OBJ_EXT_NAME(__short_size)                   \
>         .size =3D __size,                                         \
>  }
>
> @@ -957,6 +968,12 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type t=
ype)
>                         return;
>                 }
>                 flags |=3D SLAB_ACCOUNT;
> +       } else if (IS_ENABLED(CONFIG_SLAB_OBJ_EXT) && type =3D=3D KMALLOC=
_NO_OBJ_EXT) {

Hmm, you have to check IS_ENABLED(CONFIG_SLAB_OBJ_EXT) here because
KMALLOC_NO_OBJ_EXT can be aliased with KMALLOC_NORMAL... Could we
instead have a helper function like this (maybe with a better name):

#ifdef CONFIG_SLAB_OBJ_EXT
bool is_kmalloc_no_obj_ext_type(type) { return type =3D=3D KMALLOC_NO_OBJ_E=
XT; }
#else
bool is_kmalloc_no_obj_ext_type(type) { return false; }
#endif

?

> +               if (!need_kmalloc_no_objext()) {
> +                       kmalloc_caches[type][idx] =3D kmalloc_caches[KMAL=
LOC_NORMAL][idx];

Could kmalloc_caches[KMALLOC_NORMAL][idx] be NULL here?
In general why do we special-case and do an early exit here? Can we do inst=
ead:

if (need_kmalloc_no_objext())
    flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;

and use the common path?

> +                       return;
> +               }
> +               flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
>         } else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type =3D=3D KMALLOC_DM=
A)) {
>                 flags |=3D SLAB_CACHE_DMA;
>         }
> diff --git a/mm/slub.c b/mm/slub.c
> index abe748b7dddb..a34f9b8770dc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2123,42 +2123,6 @@ static inline void init_slab_obj_exts(struct slab =
*slab)
>         slab->obj_exts =3D 0;
>  }
>
> -/*
> - * Calculate the allocation size for slabobj_ext array.
> - *
> - * When memory allocation profiling is enabled, the obj_exts array
> - * could be allocated from the same slab cache it's being allocated for.
> - * This would prevent the slab from ever being freed because it would
> - * always contain at least one allocated object (its own obj_exts array)=
.
> - *
> - * To avoid this, increase the allocation size when we detect the array
> - * may come from the same cache, forcing it to use a different cache.
> - */
> -static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
> -                                        struct slab *slab, gfp_t gfp)
> -{
> -       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
> -       struct kmem_cache *obj_exts_cache;
> -
> -       if (sz > KMALLOC_MAX_CACHE_SIZE)
> -               return sz;
> -
> -       if (!is_kmalloc_normal(s))
> -               return sz;
> -
> -       obj_exts_cache =3D kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0)=
);
> -       /*
> -        * We can't simply compare s with obj_exts_cache, because partiti=
oned kmalloc
> -        * caches have multiple caches per size, selected by caller addre=
ss or type.
> -        * Since caller address or type may differ between kmalloc_slab()=
 and actual
> -        * allocation, bump size when sizes are equal.
> -        */
> -       if (s->object_size =3D=3D obj_exts_cache->object_size)
> -               return obj_exts_cache->object_size + 1;
> -
> -       return sz;
> -}
> -
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags)
>  {
> @@ -2168,14 +2132,20 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
>         unsigned long new_exts;
>         unsigned long old_exts;
>         struct slabobj_ext *vec;
> -       size_t sz;
> +       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
>
>         gfp &=3D ~OBJCGS_CLEAR_MASK;
> -       /* Prevent recursive extension vector allocation */
> -       alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
> -       alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
> +       /*
> +        * In most cases, obj_exts arrays are allocated from normal kmall=
oc.
> +        * However, normal kmalloc caches must allocate them from
> +        * KMALLOC_NO_OBJ_EXT caches to prevent recursion.

For debugging it would have been convenient to allocate all obj_ext
vectors from dedicated caches... Maybe we can do that for
CONFIG_DEBUG_VM or someday when we add CONFIG_OBJ_EXT_DEBUG? Anyway,
not really a complaint but a wish.

> +        */
> +       if (is_kmalloc_normal(s)) {
> +               VM_WARN_ON_ONCE(!need_kmalloc_no_objext());
> +               alloc_flags |=3D SLAB_ALLOC_NO_OBJ_EXT;
> +       }
>
> -       sz =3D obj_exts_alloc_size(s, slab, gfp);
> +       alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
>
>         /* This will use kmalloc_nolock() if alloc_flags say so */
>         vec =3D kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid=
(slab));
> @@ -2193,8 +2163,21 @@ int alloc_slab_obj_exts(struct slab *slab, struct =
kmem_cache *s,
>                 return -ENOMEM;
>         }
>
> -       VM_WARN_ON_ONCE(virt_to_slab(vec) !=3D NULL &&
> -                       virt_to_slab(vec)->slab_cache =3D=3D s);
> +       if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> +               struct kmem_cache *exts_cache;
> +               struct slab *exts_slab;
> +
> +               exts_slab =3D virt_to_slab(vec);
> +               if (exts_slab) {
> +                       /*
> +                        * The vector must be allocated from either norma=
l or
> +                        * KMALLOC_NO_OBJ_EXT kmalloc caches to avoid cyc=
les.
> +                        */
> +                       exts_cache =3D exts_slab->slab_cache;
> +                       WARN_ON_ONCE(!is_kmalloc_normal(exts_cache) &&
> +                                       !(exts_cache->flags & SLAB_NO_OBJ=
_EXT));
> +               }
> +       }
>
>         new_exts =3D (unsigned long)vec;
>  #ifdef CONFIG_MEMCG
> @@ -2217,7 +2200,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                  * assign slabobj_exts in parallel. In this case the exis=
ting
>                  * objcg vector should be reused.
>                  */
> -               mark_obj_codetag_empty(vec);
>                 if (unlikely(!allow_spin))
>                         kfree_nolock(vec);
>                 else
> @@ -2253,14 +2235,6 @@ static inline void free_slab_obj_exts(struct slab =
*slab, bool allow_spin)
>                 return;
>         }
>
> -       /*
> -        * obj_exts was created with SLAB_ALLOC_NO_RECURSE flag, therefor=
e its
> -        * corresponding extension will be NULL. alloc_tag_sub() will thr=
ow a
> -        * warning if slab has extensions but the extension of an object =
is
> -        * NULL, therefore replace NULL with CODETAG_EMPTY to indicate th=
at
> -        * the extension for obj_exts is expected to be NULL.
> -        */
> -       mark_obj_codetag_empty(obj_exts);
>         if (allow_spin)
>                 kfree(obj_exts);
>         else
> @@ -5356,7 +5330,7 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t flag=
s, int node,
>         if (unlikely(!size))
>                 return ZERO_SIZE_PTR;
>
> -       s =3D kmalloc_slab(size, b, flags, token);
> +       s =3D kmalloc_slab(size, b, flags, token, ac->alloc_flags);
>
>         ret =3D slab_alloc_node(s, flags, node, ac);
>         ret =3D kasan_kmalloc(s, ret, size, flags);
> @@ -5419,7 +5393,9 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PAR=
AMS(size, token), gfp_t gfp_f
>  retry:
>         if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
>                 return NULL;
> -       s =3D kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token)=
);
> +
> +       s =3D kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token)=
,
> +                        ac->alloc_flags);
>
>         if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>                 /*
> @@ -7979,10 +7955,10 @@ static int calculate_sizes(struct kmem_cache_args=
 *args, struct kmem_cache *s)
>                 s->allocflags |=3D __GFP_RECLAIMABLE;
>
>         /*
> -        * For KMALLOC_NORMAL caches we enable sheaves later by
> -        * bootstrap_kmalloc_sheaves() to avoid recursion
> +        * For kmalloc caches we enable sheaves later by
> +        * bootstrap_kmalloc_sheaves() to avoid recursion.
>          */
> -       if (!is_kmalloc_normal(s))
> +       if (!is_kmalloc_cache(s))
>                 s->sheaf_capacity =3D calculate_sheaf_capacity(s, args);
>
>         /*
> @@ -8548,7 +8524,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
>  {
>         enum kmalloc_cache_type type;
>
> -       for (type =3D KMALLOC_NORMAL; type <=3D KMALLOC_PARTITION_END; ty=
pe++) {
> +       for (type =3D KMALLOC_NORMAL; type < NR_KMALLOC_TYPES; type++) {
>                 for (int idx =3D 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) =
{
>                         struct kmem_cache *s =3D kmalloc_caches[type][idx=
];
>
>
> --
> 2.53.0
>

