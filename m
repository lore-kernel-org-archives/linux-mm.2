Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B22D2D0E9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720B76B0089; Tue, 13 Jan 2026 07:48:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE4A6B008C; Tue, 13 Jan 2026 07:48:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D00C6B0092; Tue, 13 Jan 2026 07:48:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4EA6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:48:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F40F71A0108
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:48:51 +0000 (UTC)
X-FDA: 84326920104.09.E765352
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2482E1C0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:48:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGW2UaLd;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNnW6s/SZBu2UFj4TzBUvNaszCcdwzNSNbMjemvajVs=;
	b=qmN7xDR5SMUN9B22Xk3ydoGbNBshqDND247T6/TcwBIkX+sYk/6zNO1ZkRAEjop6LA+1Ek
	jYWD2WzvaIUz0gBdCJur+HdVbRjocr1YHWkCUwXpuvgTQtFhmw/KYOEU/sMQFJXMJJVPHe
	K4UPEYvDu0aP2m/N2AviUgUsDjR/17I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGW2UaLd;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308530; a=rsa-sha256;
	cv=none;
	b=aQn2Ydcf3WhZUw+cLFZVE9hvKmk7aRp4iQrM5i5FC9u9SDgezAbtkNKTcZ7do+E7Q05UtU
	GsK3iJpOS8Qh02ozSNhaJoYSwUiDG+6yQrU5GhSjQeD2oHoSHYAWQvwaRSW+ktnh0fskUc
	UDOVoNbJ5gQuFrIYZ2ANfhAR0dwle9o=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78fb5764382so78811577b3.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768308529; x=1768913329; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNnW6s/SZBu2UFj4TzBUvNaszCcdwzNSNbMjemvajVs=;
        b=GGW2UaLdhyqrGYWCSfXhswNvfYtqOKc6B1sbWMGZ3Nmuzpk0VvKm2evx8kwJQQSpmV
         si9oe+0m+v/5g7bnIQtwYlYK3KhSYWu+lt47nT7pfZV0d2IikG/em6u8Y8wTwRqQbcdJ
         khg2ISdRc+yXutkMvSArdDAxnQCtcMiURRqdRSywuV8wo/+M7RdLSHOeSeP3kEdKJUaA
         +Qpg91FDQ60BwslxNs8MeNv0Ayrbd3BKvNLbTnYSm2ZF4ett8DUdkHISRm5gUNtxdVxF
         I07WxJWnD4edKHqw0RtV92JPPtynKOTHRptDhXmiNG95PwM6CB/lLp28CEIWjCJ8Uk7B
         S4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768308529; x=1768913329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mNnW6s/SZBu2UFj4TzBUvNaszCcdwzNSNbMjemvajVs=;
        b=sYKAAA21hbnJvAghycC4Wekqvk1+BV5ftpIyAcrT7kGUF5xnNuUkX2NScEFWyItSgx
         12ik6+cxH7R4ilgBpUOYlAJDqE6V4MQtB883PTtxauxCI7mOlU5P8KvzztakBTwHdvyE
         521uwtgwPx6HvEILyDr3SLusoT+0NgZbBhONWhtGs9NZvUf8YGFMYnZ9CBgoMWK7KQ39
         rf7TYKVqVxAMlucCXOJWZFQzzYxXeVkPsHfMhWY4OG0emXvzzYU9jOuvHovcZB9aNQ6x
         SqJUyqazImARD6sdAsPKpdH1pnzUhf2x7Gryq9apl7Lo/cdQeAJNYwwHkVnaMkuGxkct
         RJBg==
X-Forwarded-Encrypted: i=1; AJvYcCW+j18OvY35vKSYlGa8JoJls+IpHB0bKmvLsrxuKDR8Es9o0JQJFxM518aCoERAll+EHtpV5e/cRw==@kvack.org
X-Gm-Message-State: AOJu0YybeFjN30tEY7/k8yQxCEVEcZNUt4/oa64q5F4AHRIsH4xOfjSU
	Iv3MKe4WfiuyWBunzd8rxfDN7HIC/8DoRCqjnxbF2RidIpU33d2lKeXEvvfXY21ziULltwpUi8o
	DxHiszTHkEMySSJcpVFO3wJ1nPZUKDCE=
X-Gm-Gg: AY/fxX6HsBNoJCVPpaNhcKUm/Z+ZHY82HTgTf155Hkcp0Vu8CkPoWlHONUzZHZfjqSC
	xi8nbpJohWRaJiKAEz05kLWlOgorB95DnRyJVh+w0AMMYgnykrHgHsRKLZadiT6sf6Bdizg6uMC
	c2yoiFXid1N+JAY1strwZ2eWPnpu9ag/SC2SBFSk7JNQFJDOT/i/l+StTZBykBi+xeKnDdMD00P
	G+klgZwDNJpD1JGLugKCSTwOT22N9/ST1eD/IykRhqgGk8ethfl3JlCpxPvxdQxxoych54j
X-Google-Smtp-Source: AGHT+IEO+jCG41UHQ6838e+tPw5huBXcqk+s+AkfZLQAlFsLAzSWXyjDX1MlYDTJJGPecL0Slihr38A2K7DlI7o25g8=
X-Received: by 2002:a05:690e:4086:b0:644:7b59:4219 with SMTP id
 956f58d0204a3-64716b5f6demr18280157d50.10.1768308529217; Tue, 13 Jan 2026
 04:48:49 -0800 (PST)
MIME-Version: 1.0
References: <20260113121238.11300-2-laoar.shao@gmail.com> <8496feb711aed72644504926d9ff358550c011e3144dea088833ad723f4fe852@mail.kernel.org>
In-Reply-To: <8496feb711aed72644504926d9ff358550c011e3144dea088833ad723f4fe852@mail.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Jan 2026 20:48:13 +0800
X-Gm-Features: AZwV_Qj-roTiKDhQLS2IgDQjyIWDFWT5_Ypxc1AEvOfjfWTRTIJJ48nOdOvssl8
Message-ID: <CALOAHbB_PNGrQ1t3Cz0P0dvLtY2tv9o4DJ=g-U1o_6JuLUNK+g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/3] sched: add helpers for numa balancing
To: bot+bpf-ci@kernel.org
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, mkoutny@suse.com, yu.c.chen@intel.com, zhao1.liu@intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2482E1C0003
X-Stat-Signature: e5ib3xxkbcwbk33xe4ezkwikwwxb3h5t
X-HE-Tag: 1768308530-473212
X-HE-Meta: U2FsdGVkX19nPrCOYjUE+vm8sE6gbv/g2/LJJySRgrz5LYF0MDq7YQ7ntbAMz2S/srzAoUSrf+nsU9To5ssC7q9yyO06eO8YpU1WyiGdoOLJaW4uiz3oScS+X6K9J6P6jysYIhcWDVHGOHZAq0ZCABXbDDCZFEqz2EhAwB4Z5kBqGP0EIP2QN9J2h7ZON7CCOSfIgJCiRVCJw/A8Jqq2W5S6FNfXb8gCvStk7TjOzLYEQNQg96Pw3gMFke0yncVn1v3pp0qsvNelzrjTgFvw9EW3T0bDwTwKicsIhPOUeol0PRKX1RRnbzk+YVMWCER4OeAM7UQ5YzK7Q8Rcj4PWhQvEyFxMy9Vw31djk+gKPgTy1RRJTpt5sl9vKjPSi+qJtiwhQ5a2cw5wNbzc5Nk22s6GX/NXaGzXHVEAM/uUV7ggEzKO4+0sBYQCm//XZxCi+znaZ2POC3koG9+dcXG2nDlEwNWqTO6TeTaUNZAdCDX0DpEceBH8Gvms5wSXBe8brscwR2q68ub7kru7aQOdSbwxc+/C4OlqIS1JJy8Aen8RRkTc6tVIqmVG6BEWRkOXLzH8V6qq4beS0YLjy9BMuZwqahwiAAVCLIlDiJ0JZh6lGjmUmMQGfZ+1IfF1I7PyZoKow1VQHJWBlLJp3LoHXJo0xv8pIu+PH3d0FixF4jLa3GqqGOSNgGjvHvn7T4D5Wv4LQZ8NABLhyRYXK5Mq3HyPEQbsbltnWmS+LeGRAbhjvfQel0RTQpNuj/BM6bnAto/Ca+UNXUwkyvLMOJxj86jTIJEhaMNcOy/x+jVBUOHF+eAAPObzvHoVugd81Ch6RbI7gnWPLl+FeguH6/8vS8GIeGRHUvRB79P+61wZGhdD6LJVvZkgcOrV9q/sKgDP6zmWlK4RA1F+N6UPJq7mDgGvWRhsj6ZVQzJdsCexADNWbzmV5ua56bw4u4xaf8nimsqnksn4t7ILlCfYA7T
 PGSh9KtB
 f8Oi4X6bzsSXGd/Vb2crcqLDhZSc3rila2vfNA6N+vipx4ls7Ls+/GRVtLNRrK7YybIRR4xlKX8ZPxhU6ftJ/lTD8IflwBFRp+2SWAcVya9cwDkOPoMZaj5zYRdnO3REJVXZc6xMWuIRTk54vfOBVTM8qfWnp3HS9b39pMh4UVPa6SjNIx5+Nkmq+qL4w1rIgBCMROpJVCano9eAg/DSagqczIan5Co3v/9+cxNG+NjdrWkFfHJKt737tRwWQ0RiMPuSXhteFH8wzoPgM+w3hiSHf2uga/frK4V7Xj8l+uEtAAWpZvGkX6MswRPMncemSPdke45m5rxDv2xQGV+bno5Cc4K+xenJe4A3ULJM0ucdzX1wrAk6mRgI8zOfv1NAiM9GwEfzyacJ4SeJaVwU4QnIjv0TposdryHjmHuo2nBC7me/RnW+8o9anW7jyRjZZcBwCAc1BvKZgLEg9HJaz8BMSyiOU5ZeJdU5+CMCb1ea1GV5j9/2aY+WgTbRZiEXycF+/9D5nx4NFQoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:42=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched=
/numa_balancing.h
> > index 52b22c5c396d..792b6665f476 100644
> > --- a/include/linux/sched/numa_balancing.h
> > +++ b/include/linux/sched/numa_balancing.h
>
> [ ... ]
>
> > @@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
> > extern void task_numa_free(struct task_struct *p, bool final);
> > bool should_numa_migrate_memory(struct task_struct *p, struct folio *fo=
lio,
> >                               int src_nid, int dst_cpu);
> > +
> > +extern struct static_key_false sched_numa_balancing;
> > +static inline bool task_numab_enabled(struct task_struct *p)
> > +{
> > +     if (static_branch_unlikely(&sched_numa_balancing))
> > +             return true;
> > +     return false;
> > +}
> > +
> > +static inline bool task_numab_mode_normal(void)
> > +{
> > +     if (sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)
> > +             return true;
> > +     return false;
> > +}
> > +
> > +static inline bool task_numab_mode_tiering(void)
> > +{
> > +     if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > +             return true;
> > +     return false;
> > +}
> >  #else
> >  static inline void task_numa_fault(int last_node, int node, int pages,
> >                                  int flags)
>
> [ ... ]
>
> > @@ -52,6 +75,10 @@ static inline bool should_numa_migrate_memory(struct=
 task_struct *p,
> >  {
> >       return true;
> >  }
> > +static inline bool task_numab_enabled(struct task_struct *p)
> > +{
> > +     return false;
> > +}
> >  #endif
>
> The #else block adds a stub for task_numab_enabled(), but task_numab_mode=
_normal()
> and task_numab_mode_tiering() are missing from this section. These helper=
s are
> defined when CONFIG_NUMA_BALANCING is enabled, but have no stubs when it =
is
> disabled.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 670fe9fae5ba..7ee5695326e3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
>
> [ ... ]
>
> > @@ -4843,9 +4844,7 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
> >       if (!current_is_kswapd() || sc->order)
> >               return false;
> >
> > -     mark =3D sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERI=
NG ?
> > -            WMARK_PROMO : WMARK_HIGH;
> > -
> > +     mark =3D task_numab_mode_tiering() ? WMARK_PROMO : WMARK_HIGH;
>
> [ ... ]
>
> > @@ -6774,7 +6773,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int =
order, int highest_zoneidx)
> >               enum zone_stat_item item;
> >               unsigned long free_pages;
> >
> > -             if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TI=
ERING)
> > +             if (task_numab_mode_tiering())
> >                       mark =3D promo_wmark_pages(zone);
>
> The original sysctl_numa_balancing_mode is defined to 0 when CONFIG_NUMA_=
BALANCING
> is disabled (see include/linux/sched/sysctl.h), allowing this code to com=
pile and
> work correctly in both configurations. The new task_numab_mode_tiering() =
helper
> lacks a stub in the #else block, so should_abort_scan() and pgdat_balance=
d() in
> mm/vmscan.c will fail to compile when CONFIG_NUMA_BALANCING is not enable=
d.
>
> Would it make sense to add stubs for task_numab_mode_normal() and
> task_numab_mode_tiering() to the #else block, returning false to match th=
e
> original behavior when sysctl_numa_balancing_mode is defined as 0?

Right.
I missed it.  Thanks for the review.

--=20
Regards
Yafang

