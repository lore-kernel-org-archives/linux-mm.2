Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E81DCA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42946B0324; Tue, 26 Aug 2025 22:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A3A8E0105; Tue, 26 Aug 2025 22:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FA16B0326; Tue, 26 Aug 2025 22:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5CB6B0324
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:31:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27F881403F9
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:31:49 +0000 (UTC)
X-FDA: 83820961938.27.87B5590
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40E4E1C000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:31:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OQ8EhWdl;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756261907; a=rsa-sha256;
	cv=none;
	b=7i0Mn/aZHDTHs7JtFunoUm8/Xxj+Gu5F0oz9WdjoBkX7P5KFzmdWR/W86/NVTWIJMy1cSy
	gS9+/3txr7ZQ/fU8MHF1fAhtvSamy1bwdPTVrINQ3cYMayOX627TjcUK6iq5HfZWrTDi3E
	nVBhDiCnAAaT+/BcIWf31v24HqSsij8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OQ8EhWdl;
	spf=pass (imf18.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756261907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPZ0cjHpX9ISkQzDoldFUyRE8ewsbgZ6deVAAiBZcHA=;
	b=Mv3vtJq6Pq+biWPf8T96Kh3nzijJqIhTi1wk13QrCghAvBG7WNS4RwR40t3sgsZnCpY4q7
	6WaLt7xOlHnh69bpAFFVHBhDYQrQX7Qn2VctF0ZSNozGOll0vXemf8FqDMqqU6WdQeWG/w
	apxRg7LJAy+mF2x6aMQ7BNzjMh7KrtA=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so33687775e9.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756261906; x=1756866706; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPZ0cjHpX9ISkQzDoldFUyRE8ewsbgZ6deVAAiBZcHA=;
        b=OQ8EhWdlOeGHbC1o75+PjzQUNrhA8J6sxpq93Lc4bF7oTqgcCtgIMt7UvROG/QHG/z
         Wz1FNO1ddUrHokhyXA7iXyJI5jpFNVmpR6cR09R4Fq8rTlL0K6TlL5CK1ieSiOa3C7Hb
         v4gfDR0sjH4BWiJT4H2EDULlq8bVIkCutnIMbOQ6hnIJnJZ6FLJURCPCwh2X80o9gBf0
         eScondVavjy8dsm6caT67qT2B0QZpp449s5sOyt6+6BjW9RKftIwmzQ4BdhGJ0GapZWc
         ildZ2aQbOkbzNyfj9H7/OUm5hEBIJpLgmRkWQsqSnjbKoK4u6xzxa99DFKuWvS2mdlXD
         HYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756261906; x=1756866706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPZ0cjHpX9ISkQzDoldFUyRE8ewsbgZ6deVAAiBZcHA=;
        b=pdtBOasRupj/+boX9yrTEHXzaVlktIY9ME8xNwwvJcIGInzPcYpxcLvGi0KgwCZibp
         P3cje5baNcSDoKTwVh6ScS7/b8XYr1o9eIxIB5aSiQp9kCNsTPMK/JKsBgKgdJnnP/NS
         EOVQ3nbrCgOxUY5UdtgMcVyuNBwH4K/OMrHvuqHQy2kiYWK8S5Srf5Q63xoo2LC5ey0s
         ZT83R34nY+n4jvpq/XzbBf095fd42D0vSAQiMQn8kDGRERtUJqErWorD0iuAdOjIUO9L
         JWVWmniXqwZp/AciOfyrJ4NjlZvTahsDB1dWZcb4fleVj2c6JbpFDW1LtmmtO/KeN5vX
         P2uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlSm4LPVtTWH3JZisJadjNK/d9Fj/KVoJC8i1ooz8/cWr5tyGZ8MX91tRlL0SeAP14WOC00uktiA==@kvack.org
X-Gm-Message-State: AOJu0YwiOmqU/RMB+eZ76+hJ7U0kkDzMIexYxpT4bykew59+RFiKwlMU
	48vhSSSUqNrldS5BJt9dqKAnJy3klAYoyHHIwHpQED2SSnw7kSIPGWVcU0FWUsTU229hHMJR/vz
	/bYhjd13bfnglA3q+X7bvlkxOV9gmdVg=
X-Gm-Gg: ASbGnct51NoLLVoS95Gf5/uon6XBBKamBN5oo9yiwG3T5agkN7mcuJMwrP6OX8K/qss
	LstVxzNnPND4fD2pS/Kk7R79izXMDE9gsfnlGsUzXmdgpIngORIm3oDBurl5s4FaPTQE+VU5B88
	FpRkpCDNonkILSGAhZWL0/bjKSinlm7+GNXFVTFEGorxfY+tWmdmNWhBP6zR7HcWR67cZH6wrVm
	kxnupl2jb8y76D9CULZzwOiHSNNt+SA/RtsO/lErHJUWkNlX7Zyf56E2w==
X-Google-Smtp-Source: AGHT+IEGvo/30kFFrtTrRRK4xdcQTRYg7nDPi1UfUAg7xHV+Ke7cIP+dwEKwVCmAa/gFohW6TR4IoCcu37qvVrTeKAo=
X-Received: by 2002:a05:600c:4743:b0:458:bfe1:4a82 with SMTP id
 5b1f17b1804b1-45b5179683dmr206749405e9.16.1756261905648; Tue, 26 Aug 2025
 19:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250716022950.69330-1-alexei.starovoitov@gmail.com>
 <20250716022950.69330-6-alexei.starovoitov@gmail.com> <aKvqT-BAXGkjW7JT@hyeyoo>
In-Reply-To: <aKvqT-BAXGkjW7JT@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 26 Aug 2025 19:31:34 -0700
X-Gm-Features: Ac12FXwjjsZ2EvcANqqa7llhwppJYGqGgQVuUglhvIlTkrBSooCtpKFyYoUNJlg
Message-ID: <CAADnVQJ3vhBsRqgYEG13neTuXbSU1hNngYmWHqKCLTRr8+QVhw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40E4E1C000B
X-Stat-Signature: o57rnf7fdf3siubpae1tkxtiqj9rp3e3
X-Rspam-User: 
X-HE-Tag: 1756261907-337656
X-HE-Meta: U2FsdGVkX189H2SyrCADE65tE1WeFKuq9yE3lptY4EWjIBxp7Qg3hZ39YOI7u/tlUwXCppPuNyZ2XFoNZ3ImjeSzgkQJ6RBA4+jOKUw6pNUySYUhE8YLojo70PqG+eZ4iznpfWrEnOHdZXopV4T5p/A3hEq15wxPcIqXlhyxgTXTYudIgtwxWqy6vwCHRN8FtfdJ07HWlbmFnpHzGCt8N+PDm89u/HtezydD7yrkkcO56Akb5tXWarUlKFGhGYR2aKWeVKeV6152t6tZwmUeuuBiXN5r2cdRljXehdTYXtTSS7sr8PNPc6pB9YLas3AkpdgsFRfAcWlLQPpusCm82GktSjg+sB9+OLwD3BT8KZNG41Z3EIuMA5WObeQlrsob7SFtJLlJzdKh6qLo4nYiY4PuJX4Pcc81LONk34aMJ6JrBbpj5Fiqbe9BuqzntkJRfUCXMfl0lNJQOSVZUid2fCzDV3t7YZFJc4YMqIh2WuTYcLV2kOpaAO05ive/edp6OWeZBL/AA3+NxV4Wu2pnHa3UnJV2ufUKnCE/XJIt5gawXuXJY8bHVsH+/m/F4VC6qRy9zucne4xpy5PqaW0H1y0ZbsXqHWU5BzP85O0epCfBCp0cyV1VAgwyUjsMwuBGFaonMH3Z2jBMJ627g2Rxgg4mqBWBPMx6puqH4lItfOTpocKlB0HXHdzNzgS4Jwvz8oP0xynO8VPP7pk8xMooa9v8vwpu6AHMvlMyqC2l76u2nlGnQ5R2VFSYZk7IQ1UPqThiXX8t3YsnIouZbLSHMsXRz5ZGWIpxGqwpl5ejAC0Vb9fkZwpWtz9AebAPuuj92egh5OfpMT1jDb996HVuCfTqosU17tMW9I1ToTniLJA51Boa1wMQbLq3bBNTb9sbGJIRCruGJwDZRsVbwLZ//k/U00PTAyr3+dAmcJ/fppy4J7VRuO7NwfgWBKP8R84odyEwxZ49cqAh/j5nYNE
 6mcceVJf
 50NKN/mfd7WAjBCNAmousBgz0lTiG3Lg2YfVWKQrBUbzbkHiHymjM7ZP0sWyDUhowH2BuwTwZWihaIG7y/mQ8L6QJ+mBO0kB0+OmxcT55qFUrNPbmxWVlrFdJQUEnIWsewPJsCAbUUFxanhRzLaME+CgarPOgW/0iMCaJn/l80mSJReoUuNeyCaQ0zpOT/BsCBcZk3apatKXjlDXFfxAEPDDhBxBnWAgbAUn5QQ3lolrD/hcU89St1PGN3CJCCMF4C1q7zDBeDtUuUMBW+dDu2ljsm26BQqKvR+K80T6zuWquvWWxXmFYOVgojgQC9EmsVDrMaKNgisA/WJ0fgLenMGh+d7/nJ3VRjLdvtqJ9SBTDGlaqz/iR6DFnZJaDblcESYEXYL2m/m270MXxB9YXkM5K3aT7HdWHQuLf8GFf1/tepIR1tUz4wFibMXNG9HPv75ZvGG5SC64dln8AQJutOjx7u9iO/YaUplN3coHTNRNyg1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 9:46=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Jul 15, 2025 at 07:29:49PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > kmalloc_nolock() relies on ability of local_lock to detect the situatio=
n
> > when it's locked.
> > In !PREEMPT_RT local_lock_is_locked() is true only when NMI happened in
> > irq saved region that protects _that specific_ per-cpu kmem_cache_cpu.
> > In that case retry the operation in a different kmalloc bucket.
> > The second attempt will likely succeed, since this cpu locked
> > different kmem_cache_cpu.
> >
> > Similarly, in PREEMPT_RT local_lock_is_locked() returns true when
> > per-cpu rt_spin_lock is locked by current task. In this case re-entranc=
e
> > into the same kmalloc bucket is unsafe, and kmalloc_nolock() tries
> > a different bucket that is most likely is not locked by the current
> > task. Though it may be locked by a different task it's safe to
> > rt_spin_lock() on it.
> >
> > Similar to alloc_pages_nolock() the kmalloc_nolock() returns NULL
> > immediately if called from hard irq or NMI in PREEMPT_RT.
> >
> > kfree_nolock() defers freeing to irq_work when local_lock_is_locked()
> > and in_nmi() or in PREEMPT_RT.
> >
> > SLUB_TINY config doesn't use local_lock_is_locked() and relies on
> > spin_trylock_irqsave(&n->list_lock) to allocate while kfree_nolock()
> > always defers to irq_work.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/kasan.h |  13 +-
> >  include/linux/slab.h  |   4 +
> >  mm/Kconfig            |   1 +
> >  mm/kasan/common.c     |   5 +-
> >  mm/slab.h             |   6 +
> >  mm/slab_common.c      |   3 +
> >  mm/slub.c             | 454 +++++++++++++++++++++++++++++++++++++-----
> >  7 files changed, 434 insertions(+), 52 deletions(-)
>
> > +static void defer_free(struct kmem_cache *s, void *head)
> > +{
> > +     struct defer_free *df =3D this_cpu_ptr(&defer_free_objects);
> > +
> > +     if (llist_add(head + s->offset, &df->objects))
> > +             irq_work_queue(&df->work);
> > +}
> > +
> > +static void defer_deactivate_slab(struct slab *slab)
> > +{
> > +     struct defer_free *df =3D this_cpu_ptr(&defer_free_objects);
> > +
> > +     if (llist_add(&slab->llnode, &df->slabs))
> > +             irq_work_queue(&df->work);
> > +}
> > +
> > +void defer_free_barrier(void)
> > +{
> > +     int cpu;
> > +
> > +     for_each_possible_cpu(cpu)
> > +             irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->wor=
k);
> > +}
>
> I think it should also initiate deferred frees, if kfree_nolock() freed
> the last object in some CPUs?

I don't understand the question. "the last object in some CPU" ?
Are you asking about the need of defer_free_barrier() ?

PS
I just got back from 2+ week PTO. Going through backlog.

