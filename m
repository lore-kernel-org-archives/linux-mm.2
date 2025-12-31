Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BCCEE57D4
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 07:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8666B0088; Wed, 31 Dec 2025 02:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776796B0089; Wed, 31 Dec 2025 02:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B436B008A; Wed, 31 Dec 2025 02:51:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562C26B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:51:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1C1B8961D
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:51:38 +0000 (UTC)
X-FDA: 84278996676.11.98CB01B
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2023240005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:51:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mv/2ORKw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767167497; a=rsa-sha256;
	cv=none;
	b=HWozth4OAOMBhhr43weCNdUItibfUhgft4nx06PtFygyH1m5mtqWFXsPBNJwMbAe4obSf8
	69rqbOv5vxIUMrmm6zHsyGVJ/9x+D14OwMgkwNbCOV805nnoUBqToI9ALidZ00O9r6ujlc
	SjdfMlpZx9ma4iu1LAXP3YTobOIvLNk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mv/2ORKw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767167497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4FoL6BJ8eGQpI9Ifz86ZV3A5o06nVwvo0WVTcpDty8=;
	b=mXbBJVewM5zNCBb6cqIn38d6vWQOrR2Xi4bsaQvCBUZNjJSDdAlaYiwuHQ3KAyZxSGr18c
	9t3US1Y3aN2HPF/cNecJKFfxfGsK1//GmpOkX1QGaoDm+yZs9A6LFGwLbrOvAvo5vV7Gr8
	8GaXmv+DKI3vcF9iI0IjwHaKfhiUXPc=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78fc0f33998so67687177b3.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767167496; x=1767772296; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V4FoL6BJ8eGQpI9Ifz86ZV3A5o06nVwvo0WVTcpDty8=;
        b=mv/2ORKweHktzsQq8HZUve0uCLhRHVoikj52ZtmdmH0OeHbb/sPCCD9hnDyM6YfFMJ
         hpn38kdD2uMWGPxqliq7gNXB+/c6ONcawpVgCgAGzfdkF+oUR0dRQ/JlWmfABaES49Bp
         1YeyoJQ045WzGJ13TTsCsd7PViYGO4OwH449oZQY3BcxnBeJAM3ifAvbPfrpQFFVwgUO
         7QlKMfLT4raP1EFV6VUedOVpq6hlFg9I2vSh8HtGwl8ACA1hM1b9wh0m9ArcX2OEe7Z/
         KRKo8Tp1O8xy4w88HyftzohlluOcbPl/D927jprwmCm3UdAD35Q/1tdLXC6hvsxpH0/E
         UxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767167496; x=1767772296;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4FoL6BJ8eGQpI9Ifz86ZV3A5o06nVwvo0WVTcpDty8=;
        b=lYhdCAaz6wLpPYHLFPmWjQM4aGamr/+APsZuoQJWGd++RpTxcDJJdp+Gclwbp4oWFM
         xA7xZzNigR7sA0kY9pofuVa9oCendhCJuwB55ce7s7xBH/2XeA1NJ0oUmzQGIv8L+gwS
         mCyLHzSX73TmdrtStpLRxKgEyZ6HYi7Qp68DQ7U8HK0iP8At+H4RSA8DXj/1n+nMRNEP
         Zt+Mox3JkvlCMc5+ucTbZiWH/ltfRPylU3EAqsADWwMtuZnRKtQl/motHUWAugYEchbz
         SFZiCC8hytr+cKLMpenrLel8S4Xr9HRTHTzzRmQzoCP6ZFqq6l0yvLLRzLOven3Cn2Ww
         sFCA==
X-Forwarded-Encrypted: i=1; AJvYcCVlgpxI80+PXwA8ojLVKYVtlmVrtzgIN7K3i/7b0pwmve0dkWBhO0Mt+uVyhIzWCahR4+Ej3qfuvA==@kvack.org
X-Gm-Message-State: AOJu0YxA8nCydTfIxwzKt60ooF6PMHuC0Cd+xtPrOY6TA6WEKOfAUP2Y
	BSuJRMrarbXwgk0IpEmxjXA+ebZC6zElOvlf/ZwLZWvZd92GQ/yLGC7cqetvzo6KviVtVXUSr8a
	6ppVmgdwtyAgRooWjX+4PIvWQznsFhB0=
X-Gm-Gg: AY/fxX6K2rNOR55v5ZJ3FxUop51BCxv9WyCiiwGDYB5DPV7xiVMTNblZJpW9bkf8W/f
	t/DcjioP9RB7D193TVWZud9WkQX1cq4IkW72dBT11C6lEMgM8d4feHfd0g/Pzds31JO5yi2Eqz8
	VRiIC4vBiS0izD4QDwvjZIkbD435ZrgF0UrkIX5qcSYGyeJ1pjdNYSdFmdBJjRzrXhQxXXL/0EY
	MFQlYokfFsvXnSSEg9xZB18IXFsnCG+kKT9vL9VWC1UASQ3EGKKPmNXyOYjYlgEv6qGjYy2e9TA
	iA7BQIE=
X-Google-Smtp-Source: AGHT+IG7vBLOnJgiH1nk4vyDl8tcZoRrDP3Sq7Ndc3H7dPAw7OglASU+n2daZSgkTx9rDXmJEVV1PsqS8FXUOjEoreM=
X-Received: by 2002:a05:690c:c4f6:b0:786:5afa:375c with SMTP id
 00721157ae682-78fb40d9808mr634822837b3.67.1767167496022; Tue, 30 Dec 2025
 23:51:36 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
 <20251231045948.77624-1-sj@kernel.org> <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
In-Reply-To: <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 31 Dec 2025 16:51:24 +0900
X-Gm-Features: AQt7F2rbXWScOtn-DPVdAbBtInij9YHNhpS4M4pSxfM4eczg8C3v1kShn-F9j44
Message-ID: <CAHOvCC602B=SSU+4HQ-Q6fuFEfxuA08G9zLLQy64gPfMK=mY-Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2023240005
X-Stat-Signature: 1g7scguj5ccg9trj1c1ezdao3k6phr1n
X-HE-Tag: 1767167496-30530
X-HE-Meta: U2FsdGVkX1/ieaXnVMVXmReQTzR58cUjWMkzejuZuxhD/gwNmeZoGsSD3yg9+L+qZwH30YFGzfZboOJ6MXgk53xgEVzI3iEHq+H8qhP7dvrKDtFQTT7k0TnT3RuJVdxOFv5pd+cQOKr90wVNf6WFUzvRoFhirrYZwTWQa4FHlSnNxauMzPeAiL1P999ZCL7ZPtEo1DQB+20pdf1CbDyhy4QjQ49Kqepkcq2Jv4UwKDRktZAFF9J2yxtZh6lpVfsnvO3b0Z1JDmQLSQq7ZAYTUx9mTcBbQp7ptGmHY+/Rt+1B4gIMUhALjXADbHXhhHvq3BCRyow1k6nwFrFranD6P3tLpoW6Jry+vrcZaTkTJYPCmSK0pRxbzvPVISyMIukVynvIVz6As+NTZk5JD3lmKu0qwlxrkVLZv67Eix/tpvWwMYeVbdDoeuWp944Y24LInbqN2gw4XdjJf7FHjAp2BMopWNv08yNVLAYIQwOWdUcEvA9kGgdSemKHacG0iLP5aFQA1Mz7XzJpcLjNRB5r8cKQpczYHfvtu2IpWfSWWJI3OH+eF3wExGnzxJ8KMBx0vEkP0HhPmCeKNZQ9Vr4LwisW/ZrqYlUdVeb7Bk2dSpTrLRK6zy0Zth8zAddluUtY5ySS0SBF/lvCRp8y1xDcdS3iEU0MEOmqkFybWDWmNoJG9CKnHZk+O5IPKiBKnRU2bmhyXH6RVpi6f9q44B2fLgGja9+z79caxUkKCAB5g219g41EtRCtWnNWD7SpyvQmTmUsrCZjptz0j+YV2bO9EyxUuKmjRIGhBsCogoSlPOI9C4Jc7quxXoqWMCgTpaHrX6yMMJgR1UqQqXyO4ECV1HwA7B5vkqPzGgNxhO45pqyiNP3YBErH0w4JEKzLio4a+awdWHOd5++wPapwN4M7uj4wqIvNe4C0aeeoB1qdgTxQ/udUQ/ddCmm6QX7gvcRQc7PdQ+QklG0Oz7QQz+O
 OzJ5VUrk
 UQbUh1t0sys/vSG0/1Fq+YE74hOIIKA4Sg9U7frRJqd1ynVWt9aUn+p916/5IU4hF+T9+VWlgVZxpq1mdNv8J7PIiwCAfJNGAmxnkrpaGkLZCmU/KAwrqnk8m9JWAtNYri5utDclmBhHRi9hZ7w5FwklJDDSNiLv3NYZr+fPdyPDfOywrkaZNefyJnj7r3/HumkwPCi//edz9tXm6gSnC/C1NeEamZUpAj99lSqlPpajBbzmL7UkYpcQHNDb8lwjvMYj85b+Aq1dRe0mk2hC0qdx2Sw/Wyoi+TLP4YW8Y9KHpphQICTZQuMRgQcO7hmNMMc1q8ekD4kS9UgeHVjbe7KtGz/MOFxGKQsHztmJOd9e+cHrnlA0r7UT6OUkLs+bjK7eTbUzYukKc41Imduu73dYKdSsGs1fuGLVYy4auqnzxz9Ybv0KBCMzXiD03qJn/FwD4e8pG3EJCvG+t6ZJuMg4orS10gV8BfkJXCd3Y9unihWGFmnz2FyV2fVvKIdxnup1Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 at 15:10, JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Hello Asier,
> > > >
> > > >
> > > > Thank you for sending this patch!
> > > >
> > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > >
> > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > >
> > > > Please break description lines to not exceed 75 characters per line.
> > > >
> > > > >
> > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > >
> > > > But call_controls_lock is not being used on performance critical part.
> > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > your patch, but I have to say I don't think this change is really needed now.
> > > > Please let me know if I'm missing something.
> > >
> > > Paradoxically, when it comes to locking, spin_lock is better than
> > > mutex_lock
> > > because "most of DAMON code is not performance critical."
> > >
> > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > example:
> > > kdamond.0 --> ctx.0
> > > kdamond.1 --> ctx.1
> > > kdamond.2 --> ctx.2
> > > kdamond.# --> ctx.#
> > >
> > > There is no cross-approach as shown below:
> > > kdamond.0 --> ctx.1
> > > kdamond.1 --> ctx.2
> > > kdamond.2 --> ctx.0
> > >
> > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > lists,
> > > so spin_lock is effective.
> >
> > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > locking usages.
> >
> > > If you handle it with a mutex, it becomes
> > > more
> > > complicated because the rescheduling occurs as a context switch occurs
> > > inside the kernel.
> >
> > Can you please elaborate what kind of complexities you are saying about?
> > Adding some examples would be nice.
> >
> > > Moreover, since the call_controls_lock that is
> > > currently
> > > being raised as a problem only occurs in two places, the kdamon_call()
> > > loop
> > > and the damon_call() function, it is effective to handle it with a
> > > spin_lock
> > > as shown below.
> > >
> > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         control->canceled = false;
> > >         INIT_LIST_HEAD(&control->list);
> > >
> > > -       mutex_lock(&ctx->call_controls_lock);
> > > +       spin_lock(&ctx->call_controls_lock);
> > > +       /* damon_is_running */
> > >         if (ctx->kdamond) {
> > >                 list_add_tail(&control->list, &ctx->call_controls);
> > >         } else {
> > > -               mutex_unlock(&ctx->call_controls_lock);
> > > +               spin_unlock(&ctx->call_controls_lock);
> > >                 return -EINVAL;
> > >         }
> > > -       mutex_unlock(&ctx->call_controls_lock);
> > > +       spin_unlock(&ctx->call_controls_lock);
> > >
> > >         if (control->repeat)
> > >                 return 0;
> >
> > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > Can you please elaborate why you think so?
> >
> > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> >
>
> The above code works fine with spin_lock.  However, when booting the kernel,
> the spin_lock call trace from damon_call() is output as follows:
> If you have any experience with the following, please share it.
>
> [    0.834450] Call Trace:
> [    0.834456] [<ffffffff8001b376>] dump_backtrace+0x1c/0x24
> [    0.834471] [<ffffffff800024e0>] show_stack+0x28/0x34
> [    0.834480] [<ffffffff80014f4c>] dump_stack_lvl+0x48/0x66
> [    0.834493] [<ffffffff80014f7e>] dump_stack+0x14/0x1c
> [    0.834503] [<ffffffff800032c6>] spin_dump+0x62/0x6e
> [    0.834511] [<ffffffff80087376>] do_raw_spin_lock+0xd0/0x128
> [    0.834523] [<ffffffff80de9378>] _raw_spin_lock+0x1a/0x22
> [    0.834538] [<ffffffff80255c0c>] damon_call+0x38/0x100
> [    0.834548] [<ffffffff8025f022>] damon_stat_start+0x10e/0x168
> [    0.834558] [<ffffffff80e21ab4>] damon_stat_init+0x2a/0x44
> [    0.834568] [<ffffffff800157c0>] do_one_initcall+0x40/0x202
> [    0.834579] [<ffffffff80e015f6>] kernel_init_freeable+0x1fc/0x27e
> [    0.834588] [<ffffffff80de0a9e>] kernel_init+0x1e/0x13c
> [    0.834599] [<ffffffff8001716a>] ret_from_fork_kernel+0x10/0xf8
> [    0.834607] [<ffffffff80deab22>] ret_from_fork_kernel_asm+0x16/0x18
> [    0.943407] NFS: Registering the id_resolver key type
> [    0.948996] Key type id_resolver registered
> [    0.953614] Key type id_legacy registered

The above occurred because spin_lock_init() was not performed.  The problem
is that spin_lock_init() was not added while deleting mutex_init().
Please refer to the contents below.

@@ -539,6 +539,7 @@ struct damon_ctx *damon_new_ctx(void)

        mutex_init(&ctx->kdamond_lock);
        INIT_LIST_HEAD(&ctx->call_controls);
-       mutex_init(&ctx->call_controls_lock);
+       spin_lock_init(&ctx->call_controls_lock);
        mutex_init(&ctx->walk_control_lock);

        ctx->attrs.min_nr_regions = 10;

>
> Thanks,
> JaeJoon
>
> >
> > Thanks,
> > SJ
> >
> > [...]

