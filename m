Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC63E606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ToM21hFg
Received: by kanga.kvack.org (Postfix)
	id 9DF1C6B05B0; Tue, 10 Nov 2026 18:11:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9900F6B05B2; Tue, 10 Nov 2026 18:11:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5696B05B3; Tue, 10 Nov 2026 18:11:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 635A46B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:11:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D87A8C0186
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:11:11 +0000 (UTC)
X-FDA: 85420757142.22.5F12C6B
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDC0B20005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:11:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ToM21hFg;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wahlQe2g3fyZOdMzE4NOHeW/SspvW2KMChHvizkHdbo=;
	b=L6pe7jF/vRB8ZFRpP5pqb+FCujdsS58lCTFaqgN4Xoz+ED+H5HPZMoEFouJjh9cy867fo0
	6LTh4TonzL7YGLQfwNtQm+eqmwyxWVbxnT3zYHCpYDOh8hYXXjT0oT6BROHYA08hjy7eri
	Km5sRbXQbr4xwm9IJ1YeZz9t7eJcfUk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ToM21hFg;
	spf=pass (imf13.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794352269;
	b=WRUyXg+9tvVxgpTUToXvKJ6NPm5dYWg2D8dbEu/5JgQSBonEBdAQsivf3Aq8OA8UFiaQBC
	T6LEt1xRT+MSXjclTo4JAEDzuR6usDtosCjJy1+DdeCwHo/zl5iGatiXDMlQ57Ga5J8QBl
	956lwGarBuCTjTfeqB4VWqHSoVGa324=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso37158677b3.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:11:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794352269; cv=none;
        d=google.com; s=arc-20260327;
        b=OZeYKVPTGuZw53ZxkJSqBgBxa461PqRDwM+3BmGors3u9Kvgh7aBihbOceb7FGS9cQ
         Sy6/apSlfByZHkHbaB2WudXQVT+6aip8ipCSIOqBpiQy/mvr9vgj12CN97BR+opbmVhF
         GwvYtPqhlAUxc314D7PZzzGgYDmkxSrWRceUt62cjPhauT60lK4aKDFABwrktAXkP4CF
         6Yd0bN2Xxl2fveFwSdYc16KmuRWvSQ0cvGDaaiswn3ZVJ2YxFDA7f3VLP6JRxh3mrEYe
         DoSKVqLbwPxd625/p1tFYILdFd/BVHPek1DeiMIIJukz9ipUX5e/g3T6OamicMaXz5H2
         JPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wahlQe2g3fyZOdMzE4NOHeW/SspvW2KMChHvizkHdbo=;
        fh=exbvcqsLrzyUTEkSY99F2kf+t76QPkkKvPx0WcDw4EI=;
        b=A4hPoA+L153+PeHEB69py0WfT5EPMlHDePm0uec3sCsrlCwqoTAyFM1weeN+BGFebN
         6905nBQ9FT00lRfobYQEdwJyYbdcBIakbUecjiApVmdAEFIgga6Nr4GMbmlwve3FOYlb
         3ZL/WvSmXosXQQyU/Vb0IWOgElF9KMLhwRwtchVTU4kAoHFBW5DuxlsGb48oRZkzhzfH
         UdEwNS/aakI543pXQ4JV5s/k47/F+yOqVdyFo5O/mE2BtqBq/xe6JmHOEHhhPS47YpBU
         2mjI10uElnXeDU6tRaF1rcZiDzsp2+aVkmOe3GSH/rCu39zdQ5uclYYr/dPP6CkgVTL5
         wPJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794352269; x=1794957069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wahlQe2g3fyZOdMzE4NOHeW/SspvW2KMChHvizkHdbo=;
        b=ToM21hFgA4D6Z3dPXg5Fa8Bb6QDgUbuQL2GKdvxD/cKl1b8IYhu0x2POaDSmkQU0dq
         TIqxASFZKQZWTuhBj4R4ayUaUUgdE6rNha5CQkQBTSdzVQ8iwEffdtIwVmRFMd4VpWEL
         95FOfZcSn25nbbzINVSi0Y77RZq0+51htXZJQZLHlO+a58RNnSQciqpUqvoATOtcs6CN
         aNVO0BUsl43sqXm5ikadVhDd93ZLlsFr6aM4RoSpFydZlcvaRyXlUicgZaqccK+QMsdR
         p2rite+RQlPF0cwENe0EJfvrBtp0U9n73W8UYcCWChzA3tOlJ8lCVCoPegtSQZD0mekG
         GeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352269; x=1794957069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wahlQe2g3fyZOdMzE4NOHeW/SspvW2KMChHvizkHdbo=;
        b=UsWZJa9qtW3gy6DaG6FnP/mou8KEjJ+qZ0p9lNBYjdHWVbqGYlsi15UDSi7rujBaIT
         OIkcdBR5F+eNMOwrolNMy2b3YqKRxws1CSuqO9XGDlAk9aQttgvPBySPVNRwLDhuJjsv
         9Q0kOnHGYqP29M/WQprW6eJc62thd8DDzJkADJ8rf/Pk4lvF0lMRlNRqWIxuHJCNPid9
         odKhc1EhFwzvqdeg5B528EuXDYxyzcogFS/HtXM0VOT7EHepM9qRgRxjLLz/pEfKMaZh
         9/07DPZT4nQg0qp1mdCceOJYErXS7Rym987egMukkOsqUwZqKXTI69c4M5AGi1ANgjSy
         J/VQ==
X-Forwarded-Encrypted: i=1; AL+hErEepvkhO/Ir+3qkNRSUswOTZho937lhMNAjOZ38n1wMy+in0hEUB7DlbPy3cO0jsu1QMcNHTmP2Ag==@kvack.org
X-Gm-Message-State: APuU4Z9q3rlaZu61EgzOlEJZ/jn+7cZb5Pq9KbLtoI6SqKvTE8SJng+G
	INMkTiD+dKONs+DBgJ0iCsTqd9ZADDo0L7amJmU08IfLn7lgS1BhtT0f3AFqPZI7ygdBryK1l2B
	ab+8/+1BHx4uRg2wsiwQ4Fuexh/oPytc=
X-Gm-Gg: AYBFou3G5a6vZ8aY9XJmdAQkuVFSRYyyxbfjNAiE5Y+DnAVjoZ8a7+C/uarNIkZI8Lb
	l47DMB9hLwdK6RqV5yTasQVzWlfaO+H8ieim5eyPl13k+aU1e4kfo/fHtvRipKNKZK+l/7WtAeE
	puevs5VMnsrZn13ApCJuQTYg2SqtkhtudwZMy3j7yK9dfOrkrWSKjm8AgrtccP0LIGNTP9rMvFz
	TGdnaJdBlZjaCcowjW/I6XNoeMVp3Ro7wzmPAg1OE4n66fn8miX9vm5AN7PrR3VwdHw5GuoYe/0
	0TCGQOX8KdVah2/UDxb6hVJls24TB6H9YP5Jifk9RZnRzAu4tenXIQ46caa16cTmraUrqUzoU/7
	cEek2N4be/RkZAjja2xwnZ4ERW3kgFP9m2v6G9uETgGUQVEyAWL4rD4sGjELGvFhJjZxOCP/+gj
	SosRQpu41B43IQROniJQ==
X-Received: by 2002:a53:c3c2:0:b0:67c:191a:b1b6 with SMTP id
 956f58d0204a3-67c6804a36dmr465377d50.92.1794352268572; Tue, 10 Nov 2026
 15:11:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110015321.611093-1-joannelkoong@gmail.com>
 <20261110015321.611093-3-joannelkoong@gmail.com> <sashiko-outbox-206041@kernel.org>
In-Reply-To: <sashiko-outbox-206041@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 10 Nov 2026 15:10:54 -0800
X-Gm-Features: AclHuK_x9P6OqkboG6qb5NIkTUFkL-irsJ3EWWNoTZvU-iCZdnPmiRbQT2ahxgc
Message-ID: <CAJnrk1aQrRE78wqd2yZWS2Sk8MiCHd9x0dveZBh5LHE5w75nkg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: memcg: read root lruvec stats from the node counters
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, yosry@kernel.org, shakeel.butt@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	sj@kernel.org, david@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	damon@lists.linux.dev, tj@kernel.org, mkoutny@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n1fqj34jzhigna6451h81sxzrfc3zs8s
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CDC0B20005
X-HE-Tag: 1794352269-320147
X-HE-Meta: U2FsdGVkX1/scESfkxMHqEDKgHPcZNt1HaqVAuTzsQ2r9w2v5p9tc3SmGmjci76RuDCQmuFIqDo5V00u4UTtUMU82LyDYP0v5GjVwsANN5oPnU4QswpEETOpvjWia6aWNAYxALE1wLn/FDc+7tBatCFL3LCggrUyybLEQlrITsq1Spm/XGd7IyUsQirYd69YOu4H+a2CoHSLznugCtCMWmtFG1arFJo6loul9f7GzHVjGVe107QCEZr8ggg4lOcKCPamVCq3IMvziMK1PTjY0FSu+8CHZb9BpC0jMitW2EoJzRUpTkNJCQ67kWo94XbgpzML66fHIHoPpu5753PHWYyHsCR07QS53X1GeL3DPuEEW8NiA5cNd8TeQLZSHE4fYitOQN3wBwyKiHR7vHUEHeRSTw5JFdZxH+WWvwvknbkQP78MovhKOs+NeLdcBg26mKEPJ8qs+28xrakrR2E3JKIYfqb2nwGzQTUcLXgtIStsSMH5BVLXyMNglwA1XsLyfSc5X+I9J67tn53girpnLSz1X53PDGg+JgrTle2pQsDq8Ty8ySsMxBrZocBnj45WRgnRaCrQLRPhdk9GjG5ayF48UrSNaSSGAKWsZTqRNkXT+5RF7qgX1KGeBotgltaYrrrvCYxyjk3zMFqpeWWfmmVWcju5j1rhG/g1pMWZwpHa18cvRn8YYqapGw7m0ST1RqEFfLLZUJfAIEhFzlZndPfBSa5RcZ0iRMKv9R23Tuk2fJeZSVjqqCm/jzJxAOf/jZxTyE6cNNd6fUdL6OV8VLlMjBwXfnaN5FQN/07mePIyJNKq4bh95YjizTlXVRRVXvcVmVFGCtRV+IPiVouY1rNX5pxEp5YPCuMApATmPvVoxQ0dxoW2BwdhADnuyu3fflkK9AiHXFOj9Y6MRMCkeZmUPAEKj766AQJ+ZdSzNZ9b31St7HV0izgpTyFxGX1uEYOUG1qAc1bQT8SPh3Y
 enRAk8hV
 ff3px0fxm6NGlCaIwW43AMpqTMUPdqVB0+p4u5tVKli4SeZRsGC3vZRDDjyOABQjOsV6ddYmrxql6cW/1CdJ5kPFoXdP8xl3YEea1EF7Fc5f87VpBf2/O4ma3N7ZqFueQetxoMIwVfLH1LJiY/7uJUow9bmWHvDrnZ4a5V4SAUqH1z4JlseYlLHW6pU9zWToVYQgFALmnR510LLcIMSSL34syGxYW9cRxeokLZTkvTiIhyv2VVRjHHk5WEx9OD9h/bm2KOQkEx7GKk2pYR/0f5YwFLEu/+//9Bsy9HKRxOj2BTq7v0YLOxzBY/JNC0JCJbQiTf73wjq/rXTOE5ByV+lXitKYULBUne2aq61m8Otc+5AKxmowtlBeGO/rcc1Rz8MhlVQDFPrBn2QHdrUWbY7vvFgao2tFkyR0ZSySWG7UR5aD2Jr0QIvIcjJQW9OM6//4A5JbbG1scvc8zFeoJbdlr+pPPlRJoKnXx3Cl02zvVwVKsXI8aF9WyX8WHq3yTBIib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 6:23=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: memcg: node_stat_includes_unaccounted() omits file and
>   writeback stats
> --
>
> commit d2ba314724a8ba015e3bf2a30f155f1beba25a8c
> Author: Joanne Koong <joannelkoong@gmail.com>
>
> mm: memcg: read root lruvec stats from the node counters
>
> This commit changes lruvec_page_state() and lruvec_page_state_monotonic()
> to read per-node vmstat counters instead of rstat values for the root
> memcg when querying stats that only track memory charged to a memcg.
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1ebc9330aeae5..2575bf2ba0ea6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
>
> [ ... ]
>
> > @@ -504,13 +511,52 @@ struct lruvec_stats {
> >       long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
> >  };
> >
> > +/*
> > + * Whether the node counter for @idx can also count memory that isn't =
charged
> > + * to a memcg (eg kernel memory that isn't accounted). For these stats=
, the
> > + * node counter can be larger than the root memcg's value, so the root=
 memcg
> > + * has to read its rstat value instead.
> > + */
> > +static bool node_stat_includes_unaccounted(enum node_stat_item idx)
> > +{
> > +     switch (idx) {
> > +     case NR_SLAB_RECLAIMABLE_B:
> > +     case NR_SLAB_UNRECLAIMABLE_B:
> > +     case WORKINGSET_NODERECLAIM:
> > +     case NR_VMALLOC:
> > +     case NR_KERNEL_STACK_KB:
> > +     case NR_PAGETABLE:
> > +     case NR_SECONDARY_PAGETABLE:
> > +#ifdef CONFIG_HUGETLB_PAGE
> > +     case NR_HUGETLB:
> > +#endif
> > +             return true;
> > +     default:
> > +             return false;
> > +     }
> > +}
>
> [Severity: Medium]
> Should node_stat_includes_unaccounted() also include NR_FILE_PAGES,
> NR_FILE_MAPPED, and NR_WRITEBACK?
>
> For NR_FILE_PAGES, swapcache operations such as __swap_cache_add_folio(),
> __swap_cache_del_folio(), and __swap_cache_alloc() update NR_FILE_PAGES
> only in the node counter while accounting swapcache in the lruvec under
> NR_SWAPCACHE:
>
> mm/swap_state.c:__swap_cache_add_folio() {
>         ...
>         node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
>         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>         ...
> }
>
> Reading node_page_state(pgdat, NR_FILE_PAGES) for the root lruvec
> therefore includes all swapcache pages, which inflates the "file" counter
> in the root cgroup's memory.numa_stat (double-counting swapcache alongsid=
e
> "swapcached") and causes it to diverge from memory.stat even after a
> flush.
>
> Similarly, __folio_mod_stat() -> lruvec_stat_mod_folio() updates the node
> NR_FILE_MAPPED counter without updating memcg rstat whenever an uncharged
> folio (folio_memcg(folio) =3D=3D NULL, such as a driver mapping or a
> root-cgroup __GFP_ACCOUNT kernel folio) is mapped into userspace, and
> nfs_folio_mark_unstable() and nfs_folio_clear_commit() update
> NR_WRITEBACK only in the node counter for unstable NFS pages awaiting
> server COMMIT.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110015321.61=
1093-1-joannelkoong@gmail.com?part=3D2

Thanks, this is a good point about the folio stats.

Hmm... I wonder if we should go with an allowlist instead of a
denylist. The allowlist is longer (31 stats vs 11) but would be more
resilient to failures (a stat missing from the allowlist just reads
the rstat value whereas a stat missing from the denylist will silently
report the wrong value) for any stats added in the future. Any
thoughts?

Thanks,
Joanne

