Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4638ECCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55F08E001F; Tue, 30 Sep 2025 07:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A058D8E0002; Tue, 30 Sep 2025 07:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942938E001F; Tue, 30 Sep 2025 07:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83BCD8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:19:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C96111AB0A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:19:30 +0000 (UTC)
X-FDA: 83945670900.10.A3D6D7E
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61B2A120009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:19:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bJ560kCz;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759231168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ypq+/ajxaG4je7HYmcqvMA1fKurMa0dGhCUD1PNUx50=;
	b=GfD7LtRYe7rvKev6xX4Zu/A2VJ2YSX/i7RYZ5IHJrEyTbTHRtmt9wKMvZRNRvgRB6eIQ7d
	NR04zhOWwGYb4xRr6gFZsV7QzkrooooBjAmAwpnrdRTOes9hUgWU/CD9JqGDPw+CW7Ujdh
	sz7j1zKiShYWFRCcdDj4tFzfJMXfsQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759231168; a=rsa-sha256;
	cv=none;
	b=mhTYtlxZ8s32uIDab4+sIUoUFwkomJ1BwxK0NNospsVLxD030SxntYVJp8r77ikrPYSCP0
	j/E4T0VRD0rybfRtXlng/bMwqBRrJiUBhXdBHX49t/1N6WFXQGoAFonqdJ/CVK/BWio2h5
	vL5qf8jJZYkPptnoPwO79xSAbZ8Ek1E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bJ560kCz;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so32893045e9.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759231167; x=1759835967; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ypq+/ajxaG4je7HYmcqvMA1fKurMa0dGhCUD1PNUx50=;
        b=bJ560kCzoBvkxTm72UvJSfEiQ4nyTDcIlxjr7dOyZN6kCeeyDwQcl9yMIcf9cAXYHE
         R5UNRT9lnTkRk0wrlAgmL2ip5/IvssgE6+n89vVuSQbpP3stO/zWEIWLwXxXXKFXA4bP
         +hb4neO60h0zeFy7RYY9oriUgzlCeFQu+EhqMc4r9HROsNmg9yNw2Km8QDcg4FVLYpaN
         jh4fITHHV9UbszfezoWqSN3j8begBX6RAPOfnhqkQjXIjUwvavp4M1ESeV9duDKxJt4V
         FwsmJAU7/nOpSmlXIp0YA8sJnAeP/K8lLa9xRZtzDGrYT84kCbDJY31+eprgwOMi7LhY
         auXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759231167; x=1759835967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ypq+/ajxaG4je7HYmcqvMA1fKurMa0dGhCUD1PNUx50=;
        b=qwrSksRdKSuhmmQdnpgrMfksTjTl+Z4x5HDhEYmMeA6pVDrK0VAalHjGkiwVGoYgQd
         Pb2dxsgU1wCNoHw7M0yKivbO3/8h/mHEO5qflMztKb7HyIHvAjOOJYDuiagfqY39VhKg
         uuorpIF6e2uo4L6EnxHv5bTF1rQ+gXAwIomkk0McFbrvnl6yncBZ/XekUbeSu7e45iyO
         TWjhjBcT/21GOpCrmYtT5p8H3GSfpuINq5UBt3IMVQpFbeKQbjV0wHPeY2X5PgXZZGzE
         OJIpNnKtxZDMoeSSxq1g4qvI7og6hWUcZvQgkPCayV9KZxlWCI42spE7ACLSy6CO+cyp
         goQA==
X-Forwarded-Encrypted: i=1; AJvYcCVN1PkGFL4vhiwRH7hQPXDRDO+cf6exywc+BvupsRbW9HkXRJEPfBsjgbpA7J8jMFyH/IFYa1moxg==@kvack.org
X-Gm-Message-State: AOJu0YyOXbHGNwvFmVATXfU8wvE7XgrAh1i5B8QWr1sxtwoDd9VMkQSQ
	yKokGtFC31ZTaxP3NxPYLimeOlj3TvVtrA3sDHJGOZUAN+Fsh9tKv8BfKnlrQ1UI2OMHrYAjJg5
	cMrhHMP5U72aWNsLptDhLTsE3+eqYhVA=
X-Gm-Gg: ASbGncvHCFfoNsihtXErsqFe0m1PgMyEh4AWGYVoad/orfOIct6M0aGd80wxd3tPQV8
	osPAxba4MikE8Fs4zSmeJ9jyR7+4TO9JLg1s6zsrL64cljwHAsRYOxW24bz2CS1tIklb58D9nMQ
	xrFbNoP6ZkoCc8Sb+NhhHHZHrsPJMRMfsNDgqY490DlulfddDN0C2iIRetNus5I2iONb2CVTgX8
	QDIF43cszniH1EKNCLDp3DtvFIhFnaJ7nOH+3f1oQ/neZI9CGM13A==
X-Google-Smtp-Source: AGHT+IFZ1fMTMwFHtaeQpXybp0NxecATfP4lqnf9y7TiHPos/hXiuxUHuUdy25b4V0fv4saKSFcmKIqnb2NB8ydX8Ww=
X-Received: by 2002:a05:600c:6303:b0:46e:37a3:3ec1 with SMTP id
 5b1f17b1804b1-46e37a34304mr173099175e9.24.1759231166709; Tue, 30 Sep 2025
 04:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250930083402.782927-1-ranxiaokai627@163.com> <aNu2xJMkEyYSdmW6@hyeyoo>
In-Reply-To: <aNu2xJMkEyYSdmW6@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 30 Sep 2025 13:19:15 +0200
X-Gm-Features: AS18NWDoOuauUwUhU_r-pegvcK1zYn6qFC4ElDPwWAuR9qeK68FX3q_eHNFaYvg
Message-ID: <CAADnVQJ-bkd2UVsZmhdb1L5ZrXjZbTnRcaJ-D=ojsoiRHmHwaw@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
To: Harry Yoo <harry.yoo@oracle.com>
Cc: ranxiaokai627@163.com, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, cl@gentwo.org, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pznr3ktt17g65ytku55tpc993fw7h8bu
X-Rspam-User: 
X-Rspamd-Queue-Id: 61B2A120009
X-Rspamd-Server: rspam10
X-HE-Tag: 1759231168-878986
X-HE-Meta: U2FsdGVkX1+E69sL38CD1pUDKQ67P2csR+hOTXyqwkXvrzuJtdKikm6ZBw2Lcs8KZwIRXKMV4S4zZWLEL7l/cG6Xwi4MGz7kPhLFWJh9W7pIAkLL8ywXIqZ7fDKvp5pC2MA5IAN6AoCBg52DC0DUaQzbARodKCEqQaD2FZcgrqgPaIhZ4aIekft+k7oFOfF0g7A6H4+5DUu1HnHZmb2ARF4WWOhmpST/Y3BW75XcoJ9UNHdOgF0fxtkpuyYp/xfqJf738jYMwrO/ifzfsrmVO2KSOkhUFR5bMF4EezkXFKjLzKilcwot3kSSWwyI31/7NQWLXRNM8CRuq+z4dAcFd6Ie94ri+n8pos0dmixnhXKhMblDNWytxXxuFMhzTicTWjqOYHF+wdkqLTlx1pZSWDGLA2qe3cmDsD3McY3pIJToZYiaJxN4aMSpS9R7I4PODheC7uB3SwhTmE1EilAUScKPOnBrgNJHwg5v2zQZRMLwJZuzey7qLxc6wsi8EkQ7oWsY1W8PG8ZRMBG6cIUPSvNNm5K5i3M56F5k+NoSUYKfmJ+2dEZ6Rvn7rA9cJ6f9L3hnC/bMTmA7pSkCMKaBAiTagv6B7kA7Ykf90WlUWxKXjBSf42bcKqFvmMdJnOisI4xE6K5ag+yjCAIOol+Bm1V64g8gZny1BU9sY2od3mtEsqv+WKP0hQuHpALDbB55DLKRASc2civHK2SWAJpB69u0fXR7RIKD0tQr/ypfcRI+pk7Aiqakq/FKXoUegIjoIodMu38bKmZTDAuqS7o63KHtS9kbKxbr+vMZtcJjrkBAJCAI5Lf6APn8R9slLj2YcPsC1j8wK/wuVlv1KNsiD2LZsHxpZauqcbEI5IJ9HBIc9+tKky9GLouVFnhRpYzUSV0CjNMW7eRqAdtIpnlgllYtzWXu1zzJEiliApRyeIG245rvNSk/QZzqWHRbTrSzL+bVn/SCXTRlqlEQRM9
 TneyYGJm
 tEBDOatSK0hsR7HPiQIhVui8GHjBpd4QvqO0U1OVk6uLcqHxlb7+o41naWmAkJVIJI8SEM1jmyVhip2fPOw5vY5hKgbYrSlDe+4gv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 12:54=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> On Tue, Sep 30, 2025 at 08:34:02AM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > defer_free() maybe called in preemptible context, this will
> > trigger the below warning message:
> >
> > BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0=
/1
> > caller is defer_free+0x1b/0x60
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0xac/0xc0
> >  check_preemption_disabled+0xbe/0xe0
> >  defer_free+0x1b/0x60
> >  kfree_nolock+0x1eb/0x2b0
> >  alloc_slab_obj_exts+0x356/0x390

Please share config and repro details, since the stack trace
looks theoretical, but you somehow got it?
This is not CONFIG_SLUB_TINY, but kfree_nolock()
sees locked per-cpu slab?
Is this PREEMPT_RT ?

> >  __alloc_tagging_slab_alloc_hook+0xa0/0x300
> >  __kmalloc_cache_noprof+0x1c4/0x5c0
> >  __set_page_owner+0x10d/0x1c0
> >  post_alloc_hook+0x84/0xf0
> >  get_page_from_freelist+0x73b/0x1380
> >  __alloc_frozen_pages_noprof+0x110/0x2c0
> >  alloc_pages_mpol+0x44/0x140
> >  alloc_slab_page+0xac/0x150
> >  allocate_slab+0x78/0x3a0
> >  ___slab_alloc+0x76b/0xed0
> >  __slab_alloc.constprop.0+0x5a/0xb0
> >  __kmalloc_noprof+0x3dc/0x6d0
> >  __list_lru_init+0x6c/0x210
> >  alloc_super+0x3b6/0x470
> >  sget_fc+0x5f/0x3a0
> >  get_tree_nodev+0x27/0x90
> >  vfs_get_tree+0x26/0xc0
> >  vfs_kern_mount.part.0+0xb6/0x140
> >  kern_mount+0x24/0x40
> >  init_pipe_fs+0x4f/0x70
> >  do_one_initcall+0x62/0x2e0
> >  kernel_init_freeable+0x25b/0x4b0
> >  kernel_init+0x1a/0x1c0
> >  ret_from_fork+0x290/0x2e0
> >  ret_from_fork_asm+0x11/0x20
> > </TASK>
> >
> > Replace this_cpu_ptr with raw_cpu_ptr to eliminate
> > the above warning message.
> >
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock=
().")
>
> There's no mainline commit hash yet, should be adjusted later.
>
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > ---
> >  mm/slub.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 1433f5b988f7..67c57f1b5a86 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6432,7 +6432,7 @@ static void free_deferred_objects(struct irq_work=
 *work)
> >
> >  static void defer_free(struct kmem_cache *s, void *head)
> >  {
> > -     struct defer_free *df =3D this_cpu_ptr(&defer_free_objects);
> > +     struct defer_free *df =3D raw_cpu_ptr(&defer_free_objects);
>
> This suppresses warning, but let's answer the question;
> Is it actually safe to not disable preemption here?
>
> >       if (llist_add(head + s->offset, &df->objects))
>
> Let's say a task was running on CPU X and migrated to a different CPU
> (say, Y) after returning from llist_add() or before calling llist_add(),
> then we're queueing the irq_work of CPU X on CPU Y.
>
> I think technically this should be safe because, although we're using
> per-cpu irq_work here, the irq_work framework itself is designed to handl=
e
> concurrent access from multiple CPUs (otherwise it won't be safe to use
> a global irq_work like in other places) by using lockless list, which
> uses try_cmpxchg() and xchg() for atomic update.
>
> So if I'm not missing something it should be safe, but it was very
> confusing to confirm that it's safe as we're using per-cpu irq_work...
>
> I don't think these paths are very performance critical, so why not disab=
le
> preemption instead of replacing it with raw_cpu_ptr()?

+1.
Though irq_work_queue() works for any irq_work it should
be used for current cpu, since it IPIs itself.
So pls use guard(preempt)(); instead.

