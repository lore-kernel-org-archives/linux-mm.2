Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F016EE57D4
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 06:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF3E6B0088; Wed, 31 Dec 2025 01:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CD66B0089; Wed, 31 Dec 2025 01:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8386B008A; Wed, 31 Dec 2025 01:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76EEB6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:10:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E230A8BE56
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:10:26 +0000 (UTC)
X-FDA: 84278741652.05.584CEA6
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F374100007
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:10:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eXMRB/Vk";
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767161425; a=rsa-sha256;
	cv=none;
	b=Mdr81RjClHbopZxL6MOz7hBkKsl4h4nVHTb00H53c7uXu4bwun0uD4eIggfhGGshbaXhsN
	HQmkR2rEvn4aDns6Fq9LRET3J2255bjnE+GQlary2x+I3J4o+WhJoXZ6gDi2/HzJQqJrho
	FePkUnuO051u+gnA70qHP26A7ncyCdg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eXMRB/Vk";
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767161425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9r9q/HW6R05VC9wcqM8cgSL8izLlZTtlEdqX2u0aDRE=;
	b=2MSipRzeQTsAQI3wK0R4flzj7YV7a9vxZJQE+BqjoXGEaWjFbZyDud3O56qSg8sl4DLGBh
	Fzk5n4fFtVDtYvX/o07laZeW1KyJLbcI10bZo4e5tD+hd6b4Q4F2zN/xEnadaZLEo7b4WR
	NJErgR9IJiKcE3rkBoA/6cTx6//YjVw=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78e6dc6d6d7so91429327b3.3
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767161424; x=1767766224; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9r9q/HW6R05VC9wcqM8cgSL8izLlZTtlEdqX2u0aDRE=;
        b=eXMRB/Vk/l5mkxMJmyQUJx7KTv+fFEOCE+xjycq5ErfmX4n5NKNJb5UUlp1UfqvAR+
         /S6e082cMTPCu3uyMVhHdcejdDE0A09wfXUll4Iw97J7H0Dtc3p6L4tBhFdg88tnp7On
         0oCaFhW3oRtGbwYnqjCsIPEM2qKDZgL2EsCUO0zEMcAKfrC5xJ2Q6b4+TlVYz4TBDuFH
         sDx65p5ppKO6dKiqYi7vTZXp5uqe+sFBxWLJrGDM9VojW6xU8EjraJdYfr7XI/HmBQ68
         noaGqfMl+4GaWSLdT+ZHq5ObkDayRNkOJCaDsiyRTi9t8ZNcilAe9OmbowZlITRPxhsu
         PFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767161424; x=1767766224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r9q/HW6R05VC9wcqM8cgSL8izLlZTtlEdqX2u0aDRE=;
        b=oiz9ThVG+fmXIN72rumrfQJxXqvPv7JcCw8unGFrstLCuEYrQyh70fH4Y0hMDLu7Pd
         gRtjU5LPf8ZYWPR5sQRKuoagEZpjfFPTMEb54aj5DmghO3xmKYepMj7IHk+IaavuwHLO
         rTxbEXkJkn9bWRsW75L4nBYMuSbcS89n4y02Pza5YkI20gl6uBhIWYr6jC5CjbvorLd0
         pUiz0MebK2DO0VPZBjZiFJbFNsFfBXU3MhrkpilSkrA/JPFcLgJy+RETBP9bZTkoZfuG
         ugZ5uSCXvD4vYx93oFzsvJqRjWe+BcaurwHjF68s0Qpw9Fcq1UgL2+zEZ9JnIuJHhM1p
         PVEA==
X-Forwarded-Encrypted: i=1; AJvYcCXkBSDHtsz052uePvKxOdcazaiE5L1IGuOBT8h6sNLkhqS/8lsB1vVObROryqsSc4sFtTvYjbgvRA==@kvack.org
X-Gm-Message-State: AOJu0YzzOvkxJTCbGF3l38bVQ8ALUFfvw9Lj1RhZg5ITsSMfp6zWCmUd
	WcSbiwMrvi+UYv0PjRbr0+1as8N27oGhCUpKOBjh5ncD+8YaGRBs9Zu+Ao5b+Cbo34wE0zwq9Qi
	tdY+3zaCYMFh5Tw6TW5zDnPjbxhYgyVI=
X-Gm-Gg: AY/fxX4U/B3m9tS7JlFYzmxXZwT3RAplI0Y6+X3IVzqRih/Qw0HYvYk5OxvFXxymGSm
	znhhbapWqMVI71ndj6E6KILAepKS8SzT5f7qtZotFxw9kBLURifGHO3eEgjeE0G3Y4plLb+i80o
	kD+dRZ/EHdenl3pYWygCIU+ATQTfBCHB+LJL5Rm5KR0PGuatbztVqYI8PTLCay+UOoGTydnBUvm
	R0T7jiCZQqvbdBsmKck6eY0iVPalZhg516gZzQPFIkps5SPJ7eTFIhqBD8/TSZ8SulO+awl
X-Google-Smtp-Source: AGHT+IG3CiE4VfA0kxmBTa3Oj/2sOXVFrfx5YN7l9eOI8MZ7NTP4vC6JxNH8znKQ52+tXTwUuMXTKsNTq76opOCbBFA=
X-Received: by 2002:a05:690e:1206:b0:646:5019:f3e3 with SMTP id
 956f58d0204a3-6466a9239f4mr29417133d50.82.1767161424034; Tue, 30 Dec 2025
 22:10:24 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
 <20251231045948.77624-1-sj@kernel.org>
In-Reply-To: <20251231045948.77624-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 31 Dec 2025 15:10:12 +0900
X-Gm-Features: AQt7F2oFtMzI2nAuWyTmZjvN-XE_TbFocFsLbq-V6IK2ZfYmXD_WPSMToo047ZY
Message-ID: <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F374100007
X-Rspamd-Server: rspam04
X-Stat-Signature: w9nqxqpe54fcnxtprwbncgkzhpaspkfj
X-HE-Tag: 1767161424-274668
X-HE-Meta: U2FsdGVkX1/dYu/frGHE3enJMfMqDNyKaZq7kjFuLuvwi5CydTB1FR1CW1vT5JRhSmHfuq4Tzhv+d6AOJ+5D1f6aO4H3BLtWo+pL9Y0Xobq1+FclDCGUvBeqo1MQYnJzn9CMrW2B/hxdA2glhk1T/gk+kTCUL8pUmYXO5omGtz0cLywOybzz/ekXfOc48wPH4tYShMVkvWSjp9DYQ5otLyIv12C3+faG4vpVQZNNKFQFeAU+IL+B6ppNb0iXU5+ynTisibQ5Mo/ajyGIg20R3Z5WdkdtT/ABIG9+JMNyBvk3hEYFSgpHYOmsxB+qK8ojiJbN+QSY3sP86MHoC3AnCGcbnLVifjupMnHe8aB+LT1n1dyWNJt3g1hSmV2rQD+1SBFeiFps+fBmMKDjpv2XbolB3T0wQ3PSRXvi2f/cbgmZEyS4yCj7LaNQPT2mSsaHtOZ682XDhE8w1lmV0fKrE5whdY0LrmSaNxbKOHJr8dFD8sgkJpB+F6h2BkTosI1Ifp2PrrbPeNvu8SZzx0/BwweSviAcNlcF0TLL8gp4q6MAp8JsVQrVJCStnA/SaK9H6kZMBYOvrgS6zJJj2VtcJ746wgF8BKr4NnchjSsTCGJkPX0Sm3WLZVbk9z1oQZfV0aCB0IV/KvA7djCLe9ZkYmMwWPk/ITM2qe8WCqY8JHN5EWIOEqHOoHga3WrGORfqGCjxjTltVps0hqUICHYl7zpDX1YA2dVp0XoIqooA1GlNawmT+kl6RgtX/ChOK0AwJ3xOqqILFkHa0kVLvPbNk2WoPrbpsROe1ZWYT+O2hi9TQH9owmpV9VoQhpLIdVThoANvzgGUWUHHgc50sLQuLAQF1LmEZ0MNO972aOJHFY9y2/YsOatvArs3bEPN/B8fQkMPv0ghsVjpVbborjxAF1+jtC0oIdrtIgv4/pM4zlbHqyt3vAiIixuUR/8R3odFl0jSegnAoRLLnco24Pi
 MfG4tyEZ
 kcwOZOTikF8vbevBfWfYVc1WMFn5CtAilXOUgrGSJnUNpCAzBHxcV1r35B6U7xeotm8tkcMsaHcu8NWrLf+gGRn8SmgWPITQVLwM91ZBMvhjIsPexHS0pyZhZSSxyIFqZ3K8dTdKCholCV/5XtOErIK0tjO4Kw5pnkomXa6Elw7NTFHLcGiDJiuAR0zh5Xq+HyRoyoEtbVu3CbMHTrzAF8KDUdbmzRTxYjHM2De6VMEYSpz2DqDcOsGfPpX9XlJaAC974+s7Izh0fQK3YiGyl2FRrgQ+k8AmPirXf7iOr36ysUf6kJKlUM8Y+ADFHUtNAe7EW6kBgAQnKMB3zAldJLZcM7IsgPRQqjRgWS8q4XXve/HTnddBzENTub8YY7R1CclDplzVX0+Vs5PMq0lTGwznCftumtu0vU6WjSsrhfOAjt8mgHIwxipe4h1eVEPM3rd9c3FhAkn7kTS6Z98qUvbsSLZGB4zsDtZIWJObSv33z24QcbbEPYRyg6+mbtAFAYeHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > Hello Asier,
> > >
> > >
> > > Thank you for sending this patch!
> > >
> > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > >
> > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > >
> > > Please break description lines to not exceed 75 characters per line.
> > >
> > > >
> > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > >
> > > But call_controls_lock is not being used on performance critical part.
> > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > your patch, but I have to say I don't think this change is really needed now.
> > > Please let me know if I'm missing something.
> >
> > Paradoxically, when it comes to locking, spin_lock is better than
> > mutex_lock
> > because "most of DAMON code is not performance critical."
> >
> > DAMON code only accesses the ctx belonging to kdamond itself. For
> > example:
> > kdamond.0 --> ctx.0
> > kdamond.1 --> ctx.1
> > kdamond.2 --> ctx.2
> > kdamond.# --> ctx.#
> >
> > There is no cross-approach as shown below:
> > kdamond.0 --> ctx.1
> > kdamond.1 --> ctx.2
> > kdamond.2 --> ctx.0
> >
> > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > most DAMON code needs to lock/unlock briefly when add/del linked
> > lists,
> > so spin_lock is effective.
>
> I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> locking usages.
>
> > If you handle it with a mutex, it becomes
> > more
> > complicated because the rescheduling occurs as a context switch occurs
> > inside the kernel.
>
> Can you please elaborate what kind of complexities you are saying about?
> Adding some examples would be nice.
>
> > Moreover, since the call_controls_lock that is
> > currently
> > being raised as a problem only occurs in two places, the kdamon_call()
> > loop
> > and the damon_call() function, it is effective to handle it with a
> > spin_lock
> > as shown below.
> >
> > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         control->canceled = false;
> >         INIT_LIST_HEAD(&control->list);
> >
> > -       mutex_lock(&ctx->call_controls_lock);
> > +       spin_lock(&ctx->call_controls_lock);
> > +       /* damon_is_running */
> >         if (ctx->kdamond) {
> >                 list_add_tail(&control->list, &ctx->call_controls);
> >         } else {
> > -               mutex_unlock(&ctx->call_controls_lock);
> > +               spin_unlock(&ctx->call_controls_lock);
> >                 return -EINVAL;
> >         }
> > -       mutex_unlock(&ctx->call_controls_lock);
> > +       spin_unlock(&ctx->call_controls_lock);
> >
> >         if (control->repeat)
> >                 return 0;
>
> Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> Can you please elaborate why you think so?
>
> [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
>

The above code works fine with spin_lock.  However, when booting the kernel,
the spin_lock call trace from damon_call() is output as follows:
If you have any experience with the following, please share it.

[    0.834450] Call Trace:
[    0.834456] [<ffffffff8001b376>] dump_backtrace+0x1c/0x24
[    0.834471] [<ffffffff800024e0>] show_stack+0x28/0x34
[    0.834480] [<ffffffff80014f4c>] dump_stack_lvl+0x48/0x66
[    0.834493] [<ffffffff80014f7e>] dump_stack+0x14/0x1c
[    0.834503] [<ffffffff800032c6>] spin_dump+0x62/0x6e
[    0.834511] [<ffffffff80087376>] do_raw_spin_lock+0xd0/0x128
[    0.834523] [<ffffffff80de9378>] _raw_spin_lock+0x1a/0x22
[    0.834538] [<ffffffff80255c0c>] damon_call+0x38/0x100
[    0.834548] [<ffffffff8025f022>] damon_stat_start+0x10e/0x168
[    0.834558] [<ffffffff80e21ab4>] damon_stat_init+0x2a/0x44
[    0.834568] [<ffffffff800157c0>] do_one_initcall+0x40/0x202
[    0.834579] [<ffffffff80e015f6>] kernel_init_freeable+0x1fc/0x27e
[    0.834588] [<ffffffff80de0a9e>] kernel_init+0x1e/0x13c
[    0.834599] [<ffffffff8001716a>] ret_from_fork_kernel+0x10/0xf8
[    0.834607] [<ffffffff80deab22>] ret_from_fork_kernel_asm+0x16/0x18
[    0.943407] NFS: Registering the id_resolver key type
[    0.948996] Key type id_resolver registered
[    0.953614] Key type id_legacy registered

Thanks,
JaeJoon

>
> Thanks,
> SJ
>
> [...]

