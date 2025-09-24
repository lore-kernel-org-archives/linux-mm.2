Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B0DCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 07:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6DF8E0002; Wed, 24 Sep 2025 03:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967878E0001; Wed, 24 Sep 2025 03:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8563D8E0002; Wed, 24 Sep 2025 03:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D46B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:44:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC1131DFF36
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:43:59 +0000 (UTC)
X-FDA: 83923354998.04.00E6193
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id D434740006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:43:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQOyD7nC;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758699837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frTPUrkK2UtIrSktvJErOKGACg/qrYMYkNJq7wZnIzo=;
	b=1XYwR5nOYPrJL5PvN33N8aEW4m6tAJSGUO7h5LTkFnfgmH9adhTiX/2p+TX6/cKgKpm59W
	hIH05VsW08sGIsuOL8qTGvATlVqvdZ6in5rqLzkUA9f/dfad+zGZJ4rOzauJvi8zBlc7DW
	JPnEm5MclyKLJZnTIjnvRM3L1YmFdJA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQOyD7nC;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758699837; a=rsa-sha256;
	cv=none;
	b=SlPFzT01cJCs4MQsUbvSHw46dKWicAb2UVJT8sTaKXzLPl/jozDAYiIQEurV47ubanU3Mc
	XtwYuGsmJXMJkKI6jipPo9pJlvSk84zsW2MAo8uDxug5wIs11n4GUx+/lhJqAEeZNmNmVq
	4W7dZtK3bHRAa+xuJDRsz/UyXaRk3h0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46d25f99d5aso4577985e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758699836; x=1759304636; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frTPUrkK2UtIrSktvJErOKGACg/qrYMYkNJq7wZnIzo=;
        b=bQOyD7nC2oXUqYyeUVyOuMXVI+uRW08l/0rlwtQgBdDZOUcrH8sVZOoaA5BlEEZ4Ek
         e4Fj3cutPP1aIUMPS1JkxyNEZ+2oVhh2l/fsPSha0ivBeZ1rEd/I1ebc2YLt6u/T9Brc
         +nSAs1z9XVS/Ci8ocaDflEqCl2NQ6jIb7QQycCPz+Tf0Q3+NrbI1ou3EingZLSpwG6Uv
         enLqsUUCbkBKI8fNMKERKnYnhnmbJPwep+G9P8s8KIkbWuUqQvIcgJh1Y1nD+oLx9W8E
         8aIstOtAzt9M1aqp+O7YrC2fvoWBlciPZWVqNCea1yoqO5Kuqcqa32w++YgQX/8kMkGP
         TXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758699836; x=1759304636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frTPUrkK2UtIrSktvJErOKGACg/qrYMYkNJq7wZnIzo=;
        b=woCBDlh6qE6jZa6vA6I2QWu4b0xxNhIhYhW+3nnoVyl5ym0kKGj5lLQNzY/H3sjPQw
         BpUnweWJUgdRhCqcOefPwZVKTEyEhvu+//kvNMFS7udZqZEmjhpBo0yzyQiTju7p0Smj
         LuWcaNzIHNIMrs0cVypeGpMw5EHM/0CXiULKAvOUueUm8ZLkReX0sHA4GgRgh18Hg/M5
         KRncyFbtNWvSG6sa1C2kCQAR41jmn8IoBda7qwhyAHpEG+hjzd1ivIJZ6MVPbEVrIF5f
         ypSJCleJeN/0SaXWbTTid3LXmZVjmF8yNHqJiLlZQyZVUnnBOqQNqRwNMLZw8FaPjOQV
         EtPA==
X-Forwarded-Encrypted: i=1; AJvYcCW7xItN4cdkxogLral35UdUY+aq5JHaJSXAiys00H/wUJEOs4XJtI0DhyS6TitgRf2bwJOjqw2xtQ==@kvack.org
X-Gm-Message-State: AOJu0Yzd4paC3s4xQzGW9+a3Nrnc3GqWyPK+WZG3sVhhW3rwSOS/NCkn
	rEAh/Qd2yvsgJKCZqyI+61YZJmfqeW0bebeYO/snMHLyOykQGO6MwbkujWwhR+Qh/iI511yAFzt
	8+kzfbSWjPVkaT7iCBnt22W96sQFiDu8=
X-Gm-Gg: ASbGncvww7x9pt6IbaJc66tRKhGPenuUOuEZVKfqUcIdw8ceV3eKGdlxDshxd0MUd5e
	RYARjipG4pNN2NYhggwLkPXYvIvn6yPNAlXnfHhzYB81FY6c9T6lioSwAw9K8sKQsdPwRCnNK26
	b6rmKOry7Idjz8vE8y6YzC07R6gNH55MnaNlxwgXvf6zQA67xcSmGVA5r2r9M0aqzRjfR9OluwY
	ZuXj/iz
X-Google-Smtp-Source: AGHT+IFeSvGFdTAg6SbA5V2QuwWWkKFqtUByAMy6HTgCTwSDkCwT/0AuWhnDCRxkb5JZaEcrx/NRUs8w/jN9j3HSApM=
X-Received: by 2002:a05:600c:c084:b0:45d:d86b:b386 with SMTP id
 5b1f17b1804b1-46e2b5959camr9036435e9.14.1758699835931; Wed, 24 Sep 2025
 00:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-7-alexei.starovoitov@gmail.com> <aNM-Esr0v_95qmEa@hyeyoo>
In-Reply-To: <aNM-Esr0v_95qmEa@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 24 Sep 2025 09:43:45 +0200
X-Gm-Features: AS18NWDeAMrjjtfpXXRptTmZHrkySpGxWA_vASLXbV5Wtzy4kLnoifAGbihM3rY
Message-ID: <CAADnVQ+7W9MBG5i-r1Bh+ya=xN13LTVLN+EYwzP9dhVo4cUnjw@mail.gmail.com>
Subject: Re: [PATCH slab v5 6/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D434740006
X-Rspamd-Server: rspam05
X-Stat-Signature: fswreztkws3kc7p81whn71i1xoy8h65i
X-Rspam-User: 
X-HE-Tag: 1758699837-293342
X-HE-Meta: U2FsdGVkX1+aEBxhmmeJ+zpLiWYafILakaiUh30tPX/uwihgHMMdTWKsXSMeWvm+YZfRJYEsVvL4aIrcLA3jGBmhW8B5U2YeaDRPaZRUyqLJZvXWXqUkdjvME9X7cEW7uUQCrEMjRvRZLKaGhwjQZvIogIJz/hAGQlSCC3DIo+CUMcXMVJTQe3v+Gt7TkcKOY4/foMe3122MD03xhOrimLck217HwKgccbfTmLF3BcKl8r5RVt/doj6H9xqnp6qSq54Znb+n7TF4nMtIRhZEeE5eUnaRxuaV0cZccnyUJNYcu4+OMwQYkWxoPBrycIJ0X+xqC6/PQbie5yQgn/mkUXShn0XN82HWxEW8njeRByNoWAWy3g62Qy1HGitcjbX7SGsdZgHAPVt2CYKnjEjhANuMIr+L6R+ta0oot+IJKh0Pto35xvmyDLs0waTqPqAIKC0gk0UzEGgwl6JAMIT4faSe6WWBKhcAQBpBzx9D5RoVYt6KSVNQ7f3BHiybegoHLEHgwDBRTz+4Cbi7Z6a9tGpYWGxLWEQdkHHp9mG51oQf/TT4x6j+Ipx9jkH9qccY/lLHE+cyyCTTlu52T0/5ctjKZWvtVrZkAgrwUpX7AofkVu7BWGaZu1AvjI/AtHqZV6fHVdciyhy81VluGuh8H6Fg+RXfBiKjubcH6jjOSTDJXiHW6QuYUaEor8kX1Lwi4wChjsBE0Kw4lxQNToOyJuuHPBsEz66EMrnaj6U5I7RbNegxShAw6E8SCmR21zMYmc7BQaCJvATwuOFX4qq95E0MDhiahR64/le3Wb5acg7OKxzqI+vp58+YSovMBhvdnuSkLZU44jFwcCgwCLQ1uYftD6jQkRskf7uRP/g/LOXvRIfwn423FUDtP6e8DMoqdQXPvgCBaJ14hF20stZ1wv1SdPghiACfdopcD/oTUbCkGXNP7RUhUSTjw4Tmrls9X4kSKXSMNQqjkYnN5s8
 kMvBD2iN
 V/+p3sdn9YRC/dGiM4JmaRoJop7BaA7VlNfUFmaAOWCaBb6EJiW7E1BYhZTQx+l7RTp4O/il++ZlV2kEq9QnwEsFZ307IAh7AQG2jN9akHAQeo3pWs2zvTHK/Oh8BswjkTU/aYCTtQgEeMfNS4XoUjcnpMvmJ1TRs4sU+9HOdZiOuPD+ppw4zCkbKwYDOkLd6cADk0ISlEMrzBVdA+vwUfnaKJf82L0oCoovhto4hmx9G+IeOcZ/zxZo3GJA7DKjaEb7GH01AiZaNVQG1HMsNCw0ptDU2+9W+4hOPP0HbjGDjCLdBUqNdmsjsS4g0XJMaKhPu7MSzCPAl9a7YpbD/YRlJIsdlGvMSD9Z1yFcyIX6dPmvGb2BpZAxaMkyj4VE7boHj7o3ZofkvyIgESXNqzSPqfstIVWZlYXJZJE4n7SAijstEMmTXGN5K1xofUxcvlbct88CeAEq9il+kiIwVtDLbgd39F65RmmL1MwtXLrBghm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 2:41=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Sep 08, 2025 at 06:00:07PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > kmalloc_nolock() relies on ability of local_trylock_t to detect
> > the situation when per-cpu kmem_cache is locked.
> >
> > In !PREEMPT_RT local_(try)lock_irqsave(&s->cpu_slab->lock, flags)
> > disables IRQs and marks s->cpu_slab->lock as acquired.
> > local_lock_is_locked(&s->cpu_slab->lock) returns true when
> > slab is in the middle of manipulating per-cpu cache
> > of that specific kmem_cache.
> >
> > kmalloc_nolock() can be called from any context and can re-enter
> > into ___slab_alloc():
> >   kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> NMI -> bpf ->
> >     kmalloc_nolock() -> ___slab_alloc(cache_B)
> > or
> >   kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> tracepoint/kprobe -=
> bpf ->
> >     kmalloc_nolock() -> ___slab_alloc(cache_B)
> >
> > Hence the caller of ___slab_alloc() checks if &s->cpu_slab->lock
> > can be acquired without a deadlock before invoking the function.
> > If that specific per-cpu kmem_cache is busy the kmalloc_nolock()
> > retries in a different kmalloc bucket. The second attempt will
> > likely succeed, since this cpu locked different kmem_cache.
> >
> > Similarly, in PREEMPT_RT local_lock_is_locked() returns true when
> > per-cpu rt_spin_lock is locked by current _task_. In this case
> > re-entrance into the same kmalloc bucket is unsafe, and
> > kmalloc_nolock() tries a different bucket that is most likely is
> > not locked by the current task. Though it may be locked by a
> > different task it's safe to rt_spin_lock() and sleep on it.
> >
> > Similar to alloc_pages_nolock() the kmalloc_nolock() returns NULL
> > immediately if called from hard irq or NMI in PREEMPT_RT.
> >
> > kfree_nolock() defers freeing to irq_work when local_lock_is_locked()
> > and (in_nmi() or in PREEMPT_RT).
> >
> > SLUB_TINY config doesn't use local_lock_is_locked() and relies on
> > spin_trylock_irqsave(&n->list_lock) to allocate,
> > while kfree_nolock() always defers to irq_work.
> >
> > Note, kfree_nolock() must be called _only_ for objects allocated
> > with kmalloc_nolock(). Debug checks (like kmemleak and kfence)
> > were skipped on allocation, hence obj =3D kmalloc(); kfree_nolock(obj);
> > will miss kmemleak/kfence book keeping and will cause false positives.
> > large_kmalloc is not supported by either kmalloc_nolock()
> > or kfree_nolock().
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> On the up-to-date version [1] of this patch,
> I tried my best to find flaws in the code, but came up empty this time.

Here's hoping :)
Much appreciate all the feedback and reviews during
this long journey (v1 was back in April).

