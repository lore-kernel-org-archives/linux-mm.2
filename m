Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79239EEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC56E6B0005; Wed, 31 Dec 2025 20:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CE26B0089; Wed, 31 Dec 2025 20:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88D16B008A; Wed, 31 Dec 2025 20:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA54E6B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:12:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60D2C140F9A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:12:12 +0000 (UTC)
X-FDA: 84281618904.07.15BB708
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9A4A9C0003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:12:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miX26lTU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767229930; a=rsa-sha256;
	cv=none;
	b=Vvm1/yZFXYuxaZKyarrRPgfbPw1y69TU1/LF9ZUqJyhT7DAESQ5Hiooumf09kmSUtYGid7
	IV+yaf3qvFMyomLUNXkJhkOJdT5P0qRCYELsaCCfpa9bchJ+5BMpdQiuY0F+LT/oWYF0Ov
	2UY7ktuCSrSmKszOSYBwXxanoRzmhjw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miX26lTU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767229930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8+YvY8jh0MaB/P/rCzj15WPLVkdajRGID3PPob1nw4=;
	b=4CjvhCjM7DMYtRDJry6gOAeI6m+qN6UTMDQ1g0FZMEd3kLkz0fvURMdGqJjE+m7KiJH+wE
	KgIEhZ65LcebQZ82pG2T2zobqQIM4Irh41TP5bT+SNDaT+YQyOR4w58X+qXlcf1LsFkE3v
	SvH3pBy9ao5LVCgzPoMCE/mjEhPBVwY=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6455a60c11fso9052187d50.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767229930; x=1767834730; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q8+YvY8jh0MaB/P/rCzj15WPLVkdajRGID3PPob1nw4=;
        b=miX26lTUiGvVgvl92e+xDkInAwHPs1vrDwmKefG6gqiAxP3JOw6v8F4/AXHN2X5LlO
         Z4+mwsAHX0EjKDcy/Wd/clFd3V5idVEZiFyRZUF1JJfHKfuG0y7eoAR/xR3ZfQJRKTEE
         IiiVPFSV25xi9rbmvxtPvulkQp3A5oin0ehrQr9Uz1jgXRRB+CMGJ49z55eO9LdtWmxl
         BLdi9K9IKNgQ6OktLP0AeO4KWIQaZ/ykH6AjU4UCj5NS9AcL30Pifr+TzcKZZLC5b7ea
         1OUwYHExg3v14VfAMg95/gn3Ey/GB0hXKG0d0EvBqEmhH44/yy2iBy03Onu5+RKVwcj3
         tiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767229930; x=1767834730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8+YvY8jh0MaB/P/rCzj15WPLVkdajRGID3PPob1nw4=;
        b=XyiDvOuUhZAddleOo0llB0hYh47OKB+hyw8IFDy5YUVgT5zLuy0J35i2lzOAh4dEjo
         essW568fqOnkXxAtcpcKVlJZ9lNnlSsiTHSDxzKd1Asq5e7FiJHTmuh19a6LLgZ/YcBS
         HjC+UfY7wry4Sw1Qc06N3D3t1tXrgzVej5y0m15xny4UhQHIWiXPRIyZ0ev9UEAXbg8M
         LceMqp5QcJfVDwp1VGqOYmfH0CELzxLfRZ0WvhuGW9fPEXqpNVuQ4g4ozU+yEH41UydI
         KAT2p2QOKOYuS9y+L+jyRsqeFwDgYsDp5gJ8PCktdromlnCqfM9gj/kU6dZ8OPlFxUXk
         O5vA==
X-Forwarded-Encrypted: i=1; AJvYcCWdFFC5N/WQc1ASnweq6Sf0AsWJmwAYLoKc+26mAWep1U3cral8hAnegTnvEDEY80KavtxvYqLs1g==@kvack.org
X-Gm-Message-State: AOJu0YxXMPvmRuoLkdwj4f485GBua1biFwThRC/GWzCYf+Ac/xDPoP5S
	c8/9hARe/wvR6QOn2fthOugctiMTMOiN7L3v2C2/rn8crd2XVVSJmjDSZzjfp7/l16/a6yE/Bl+
	cUVMh3IePRKW56WViXbT8HQyB1MjQ4WgzpwxsPvw=
X-Gm-Gg: AY/fxX4TDtBGLjXA1OBFjWdDrh+XAYTsutzNxSv+3RVLq55O5k47T44dz80zkImWVss
	yap8I0KF0lPwyphpvx3IpeB2YUGvux1oGXUDW1hvhN+nt+EUMaOrc7uKHjpgjZ8d3igAFuYVxzm
	h0mCw/+AD0A9XAxQdZCKEvJz3FFk0FRktFKm95CYjXnfL3qzREwvjYenDZMH5+4UiMDiXEIDsRW
	T6H5zSb0eqOWnGY8FIGjKbno9C3HzQ8KVJcKOmR7/9GEIi4YW7ki7jA3n8gmJwZV4xnRg55
X-Google-Smtp-Source: AGHT+IGCc5uZ6Q6Zr+ExY3v3MnpAaFNuiKpOrpZfNg5ZQDhkIzEhwB4cusuisLKmOh7rlI9U2s8tvivxYvYBnExHtCs=
X-Received: by 2002:a05:690e:1189:b0:63e:3011:58dc with SMTP id
 956f58d0204a3-6466a843f4amr34450374d50.20.1767229929648; Wed, 31 Dec 2025
 17:12:09 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
 <20251231153216.82343-1-sj@kernel.org>
In-Reply-To: <20251231153216.82343-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 10:11:58 +0900
X-Gm-Features: AQt7F2qnT-PD4FKqqWfJZ823JyVjjLnvf35NzBoZo0u3yNRx2gXMQAYKNQHa-uY
Message-ID: <CAHOvCC6or4a5YM-byNFkB4q8v8YO=ZrT0VymYQfSXEx84wgeZw@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A4A9C0003
X-Stat-Signature: wm3d8ttwtio35q1i6zjnxxkb1t5f5rk1
X-Rspam-User: 
X-HE-Tag: 1767229930-853650
X-HE-Meta: U2FsdGVkX18yaoJR3u/wk4v9yCPb9BpTI5P0tP3wvZU1zFvjEngNFAvGvtBORztvWdpKQbdbczd3BvTM1aBCmSn+pqkFaXPijavMB9tdHzD7HI87uSK4y6eCYK3VPwIP2TniElJqs07UwrhiyyDo+shm3eOlVQ3ro2l0Mn/Z7AvtDMVw5WNfpjn22S3Y+0p4h7ZERYz6M7lPLItIFTSuqR3bF9vgKBLbB2kwfdqZr6y34KxUt9wrLJvdjEmjXPm3ujdkCvxfwUfH/7VWHDzvadNCZQfE1c/aI06Fh04aB3zfAz+58jgI622um46Hwpqgc4f9nV+klBmORhjVMhPcPRHwEbpfFBenGyPZxgdjrwgiMhAvmxzYw9dJO3viCzREVqSc8H4y+03CE6OX81HQintEvOc6yergYKoXuHeoa0B7WelcZpGbMoLauw7TmEf77ctl+JgMhR89oFgi1YH+iwJUfgNKJswUFkvz8fJO66qQW7XAMw6H9389hGF9gQ2gnwOKrlA1kS9vV/Z9Y9XaY8ymbx5fDhd4SuCie+2NNEpKhUQIKEMI9qe03ZVStWf28axpsYdqkFfsbhULUadnaWz0XKgEqWzMb4M2WYbr4tCqUlmRMPSpGq2NCk1AUd4Oc6Rzs96nkv/P5GcHdb2zAYWjvxdTcii8ktg0ziNnbKf252RV3i7FwTkvlW3/9E2rLhLkDQNz2gn8XirAvQL6anibOyRGzbORc9JWeQ/vOTP47ipPTJ80TCmcfB2FYpfDlBVse3G4L+b4H53pBk/2r6jzM8T4hbbCUn8fLIWCSesJBRfmOfcoFScm9tobSrZ9DxQqio8E7WpL7PrAsSgLCMGXRVPDWNlWdZ1Jl/cj176BAMeHMj+XKeTtIBpTL3b8XZxLDA7nO1CpTm1tZO0+ttwv3XF9cKUqljwvr/pRxeuDeQP/O7+P6+i+EA0uYt+SQ4fxVjaHNMtbL8Yhcce
 LOurywhJ
 Q2N536vY83+j7qMC94fS9We3nf8IVABYE3QNLuRraNuGkY9s+ZXJ/liOi05ktZVSRleHjuVOtB5aZpNr5wqNvaWHcZXSj/0D8mqDw0Q//203rR1C+Ep9Hr+mTOUu6s7iA73lIVAwiuBNN5WBPFCwK/sUGhrON5lgShqWTOblyNVzAteK1kiXVWcLmhm2CxwmBTnqjzla6BLc2GHDxTu3PcxpH8PPm1hE/DSGMBQZrlv5TkVaSu1OCt32vfj6qV6YeAHVsyNSLqnljiGChH6M10oJu+7jPmpFKiLQVRx203pT8d0yHETuYN2k9E97l675uehLyUGMClHJiFa6B+9BEEa5k4jdkQZI2V1gp0cCPhohSsCfJuPq+qr3VEkA6Dq7syJQ4Lf74u0wBlYTAnIq/6v3gBQGaLTUaEWSFdO8NmNgv6IlzCnglJlDUSC3cIlyoCTUO5DPb9h5zi+GEUTe8RiHAzTlggrVT35VFw+pn1viK2M5XADaaFDc2orQbt9YUjyuw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 00:32, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 31 Dec 2025 15:10:12 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > Hello Asier,
> > > > >
> > > > >
> > > > > Thank you for sending this patch!
> > > > >
> > > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > > >
> > > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > > >
> > > > > Please break description lines to not exceed 75 characters per line.
> > > > >
> > > > > >
> > > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > > >
> > > > > But call_controls_lock is not being used on performance critical part.
> > > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > > your patch, but I have to say I don't think this change is really needed now.
> > > > > Please let me know if I'm missing something.
> > > >
> > > > Paradoxically, when it comes to locking, spin_lock is better than
> > > > mutex_lock
> > > > because "most of DAMON code is not performance critical."
> > > >
> > > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > > example:
> > > > kdamond.0 --> ctx.0
> > > > kdamond.1 --> ctx.1
> > > > kdamond.2 --> ctx.2
> > > > kdamond.# --> ctx.#
> > > >
> > > > There is no cross-approach as shown below:
> > > > kdamond.0 --> ctx.1
> > > > kdamond.1 --> ctx.2
> > > > kdamond.2 --> ctx.0
> > > >
> > > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > > lists,
> > > > so spin_lock is effective.
> > >
> > > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > > locking usages.
> > >
> > > > If you handle it with a mutex, it becomes
> > > > more
> > > > complicated because the rescheduling occurs as a context switch occurs
> > > > inside the kernel.
> > >
> > > Can you please elaborate what kind of complexities you are saying about?
> > > Adding some examples would be nice.
> > >
> > > > Moreover, since the call_controls_lock that is
> > > > currently
> > > > being raised as a problem only occurs in two places, the kdamon_call()
> > > > loop
> > > > and the damon_call() function, it is effective to handle it with a
> > > > spin_lock
> > > > as shown below.
> > > >
> > > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > damon_call_control *control)
> > > >         control->canceled = false;
> > > >         INIT_LIST_HEAD(&control->list);
> > > >
> > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > +       spin_lock(&ctx->call_controls_lock);
> > > > +       /* damon_is_running */
> > > >         if (ctx->kdamond) {
> > > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > >         } else {
> > > > -               mutex_unlock(&ctx->call_controls_lock);
> > > > +               spin_unlock(&ctx->call_controls_lock);
> > > >                 return -EINVAL;
> > > >         }
> > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > +       spin_unlock(&ctx->call_controls_lock);
> > > >
> > > >         if (control->repeat)
> > > >                 return 0;
> > >
> > > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > > Can you please elaborate why you think so?
> > >
> > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> > >
> >
> > The above code works fine with spin_lock.  However, when booting the kernel,
> > the spin_lock call trace from damon_call() is output as follows:
> > If you have any experience with the following, please share it.
>
> Can you please reply to my questions above, first?

I have answered your above question.  And, since call_controls_lock has a
short waiting time, I think it would be a good idea to consider spin_lock.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

