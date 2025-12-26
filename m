Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D149AE7AD4B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 01:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9226B0088; Thu, 25 Dec 2025 20:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86926B0089; Thu, 25 Dec 2025 20:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B933B6B008A; Thu, 25 Dec 2025 20:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65ED6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 20:48:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6246FC1D60
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:48:45 +0000 (UTC)
X-FDA: 84259938210.28.C21BC36
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92DFD180010
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:48:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PbItOxs6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766713723; a=rsa-sha256;
	cv=none;
	b=FwlOH8bXDeWL9ivQnOUMyt1jYr9+ZOpAE1fpiER4UNfPhXcynecXlyIMXQ6965z0jIt2G8
	KEz9CPHkyvz1suzc3yY0hzZv5ru3hADmnmUK0+lrP/yQ4q+tB1QvDU5+4K/h2UeyKswmGO
	nq4woIeyVgTbkwOw9O76zGGN1Ov0U5k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PbItOxs6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766713723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0ep1z35kb4XqhwawCGHg9stDipapmGII2XgTZosfBE=;
	b=sxh15Z3nIthBE0rrwe5hKaueAzvvGIMp++UAUg1tj+P1RikrkrOtqUHqOO60IfBa8e23iv
	qgtS9Lq7QkeURZuiWy/Ho8soNOFHMMl7H4Zw/5Vj7I8VPIQ9h0hTDvXODVcpPh7zQ92OLO
	PcYfetxSIKadt3ACvkUrE3ZahOMrw3o=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-78fcb465733so42321347b3.3
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 17:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766713723; x=1767318523; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L0ep1z35kb4XqhwawCGHg9stDipapmGII2XgTZosfBE=;
        b=PbItOxs66zVS+EU8dnp59mq/PEiLVzOZgZKcCUede8XDb4yexJrpQC0caUTZOTWVqN
         Qhy7EvmjxxXfGPmPpIsm6y2EzhgZb8fy6CkEpNkgf5WaIkRukV3HT16oR5HEeamrjGWa
         TmCfv8dEuvUv4VnmzlfLTNdO8ylEgoWViUmGq+dKHjVE2193tLHoZQ4PaLES1QvyM1oM
         jMatAT6FQB2apDeKxOoIwUsleJn1kqq2J9G143HY7dZlHcEaDqhbKqXNViIgH+Ly1ket
         8p2Y12JtX6ba9xDGP+IFH5X+0Lz5C3ESLF2vkVB2OQOXptdWumd5lPnJ3HPTEJYj6pgf
         P/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766713723; x=1767318523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0ep1z35kb4XqhwawCGHg9stDipapmGII2XgTZosfBE=;
        b=pIFAOxFeQVFyLh29+1D7H1/sD5qeAAyk4cQ5d6jFMwS8iVnYT2pJX7QJpkziUaoy1H
         0oQvh61Jq1DmWZGg9/p+sHP9O6E5JnHAd55s4Cuhpq1VcjbnXV9mA1RcPyaVp8+uq7Mz
         62MbVFdeluIgWti+yZinhhV84FkPHUNZgumofp5pGrwS1VWWtqdIuRktM8jUpYracIgG
         q4QOhVD8uHIvVW6yo5/LfyY/+BeZUM5UjOfo1AWRWhlfVcbp1nKsq6izm5hQa8NsAgcW
         WotihNi9WCBDd9AnIhW1ji88c74I0JDkh8YMr4kD8gQkxv2noYvodw5F6IJOcssK8z6k
         aCfg==
X-Forwarded-Encrypted: i=1; AJvYcCWPWKxALMnC7aALor43583UV5oVgudZ8a5P/HMYEL5inierRN3r2OB1xkeaB3mB2jC90xbbDnVHBA==@kvack.org
X-Gm-Message-State: AOJu0YyI07pWoNILjDQyh9t0C8b42SRGCcKf7SEk4IsrjGO3No42QHRn
	me236B+czTvXTyimnjE2NiZkrmbxqzqqJB5DkExkSV4SuSRVvt3PqR+J49MJdLBraKX+2+oW/gQ
	EmyPEVR4mxyXsui7y+j96PAZwgyv2zew=
X-Gm-Gg: AY/fxX7Qmwjwe38hZPvoRNulrkWMwYf+2qYPMhPejkCdkvIoMyXusXZ1FniUv2bH94J
	ehNNU3otKVh1gB1b6wc7EE5q8AkMV/at4Ex+PBm7OvjIXOGHQB5P4jI4t1Qw9UCoGeHsUmpF1iv
	wHxydj9Vti3BtDGdJnHnfHl5WklxknCihuSgkd1O1WRNpROwrAzso2aLz4g2ew2Cdv7cu5OxotI
	vzK8OAEmxK0CfCpUR6NJ0srjzaYIQ5DWM+yGaUTlSB22QoVo0I7ViVeO8BkROBywHnqkwxZ
X-Google-Smtp-Source: AGHT+IFNGh+EhBl5YKWIccHNZjnVnlz9LeE/BAUD/ku8d3EKlnra6wOjAaLjvI1k6A0RAHKbL7wcOwKeI7dwj6eJuLQ=
X-Received: by 2002:a05:690c:600e:b0:78c:5dfe:1b57 with SMTP id
 00721157ae682-78fb4144855mr191337757b3.38.1766713722643; Thu, 25 Dec 2025
 17:48:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4zwbiLXRTHav67GcngiVZ-5GESqkY9juLtqAfWQW1UQg@mail.gmail.com>
 <20251225194959.937-1-sj@kernel.org>
In-Reply-To: <20251225194959.937-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Fri, 26 Dec 2025 10:48:31 +0900
X-Gm-Features: AQt7F2oTYniRPCSfdt7CQ8r-hSgU5_yIqPxO-RpmUG-RrdVNJtAYkSSbx8YfbGQ
Message-ID: <CAHOvCC6PQKAK5WojmVFqBw0V-TZ+11CM_2uq4z8TxsyEu3gLVQ@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at
 the damon_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 92DFD180010
X-Rspamd-Server: rspam10
X-Stat-Signature: knt9omu7xtq4pjm1ywm7h6egr4jmgqi7
X-HE-Tag: 1766713723-801817
X-HE-Meta: U2FsdGVkX18tUw73QlrznnJNbKykAwTWVa+FHWtdQhBJVb9lHUDfoWpYC19w0xkbjd0dx7YxNgs3rq+buKKY8PPr6r52eHwIvgwHNjNiXqATSVqIIqPrP9jcpAvYQHtkw5m9EimdUdc92O28Z2vkoiAdcwgZ4qhFoelcsAS7a6740ohvo44fCzoqtPU60TWQb8eNGzKJ7rLjs3qUbsbHCGU0btELiQq98tTLGR9jZAIxDVMIabaaBNsHaps+OVzESK2EQXKF6ilEwwfKtH7Hq/qIt1Mlm0sB0ltpcwY+Tgwhv+/H312Ztun0bxWLKosAfOka+JII8zTeforH6P+CUmFugQI0HSna5cetBzsaGSbYPHY6sHyiVhC/ayaSbv+vPimtJfl5Bdl3jY7FPowj6HWA1RqC9Pxw3IdEqYFW9LvMNF5MHRxtG/06zi5vUoDElStFuMyPWGRGiuzBrLOUVTrgJ1MtYL5qTUzjmGnlBiZypGSLFw7uI/TUY0IDqrNJN+CoEUvYMPwqwhPGyQqUjunygLC75fcCvNsBOfbZRks0ySyUBR1TNuHejnVPDpVm5Os89QgjZjqvOg0Gvb1vq9lXFv/e9rMeoVrmOTkFvRbj1vPi0FVKeESJqPBUiS1wskHdOHwpDqHc1SJODK2JcezXR6iOjcKuOGS3pPt4CqK4avYSLFO6LyYYxt6RSjhA5wfdlauXgydMHFyuhAfI7w1XbGhdOZgS+syjJ8vmgBo8mkH7wLJbHAiRVFd/gTCbauhBKh9bXVjkMqDURyPvTPDlOTqLuTLDkjQhRJ/yycXyKiKUlds7D8aP6x0c4rhu3VrwSnhfe1z7fn9kT5JqTGl7QIWNfjYnOev21ydVpqMQv4DtNDOgQuGmPfYrlp8eb0joXthqfqnoRtDF3ykCmTMhB2N5WDDkgwItjsr/7wZRhd1N8NAu6nTu1+++/ENlXBHWworWXipXibvLNqW
 CWrCV8uJ
 aaFdyCGHRi2NzqKRrqbPChZbwwd0UCz94kSJaoyuPFltlipYxZVa/KsMNGIcdvJHenTCkXyaAXfNqljcggOcmULbNIVTny5LlRUzhAhZ+6o38LpGEKpzEkiXAUYXhujO8TqbsxQesbrfa25GDx5K2Q7UHPOcyqPETdJK0r6EL4QSOGGIzA7PmEpfQwSel4G3gI9sEe+TGEMSJSh0Rk9KiRuEirAq7mldun5NPzsFtTUWnvIo8zXrmN14THZTwdBcdU57QGuS3KbEIrO2QxNsH7q91B/+X8hMDVggKVd5KJ67nnnU+q8DUBpnAR+8pAwqkFpRSBfU7sCq06ku+XkE7TkSIsZBkis4DMCG/Cc4icQAkj3FY5+FfExIiszV5109nA+KtduxVoJpe5Upwng3YwihwQYevX20TRdxJBSyduBReNIkb6K58JhNnB2pQwNxWhdPeE+LpXrDr30rqzpJblVshJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > Hello JaeJoon,
> > >
> > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > >  cd /sys/kernel/mm/damon/admin
> > > >  echo "off" > kdamonds/0/state
> > > >
> > > >  echo "commit" > kdamonds/0/state
> > > >  echo "commit" > kdamonds/0/state
> > > >
> > > > If you repeat "commit" twice with the kdamonds/0/state set to "off"
> > > > with the above command, list_add corruption error occurs as follows:
> > > >
> > > > 4-page vmalloc region starting at 0xffffffc600a38000 allocated at
> > > > kernel_clone+0x44/0x41e
> > > > ------------[ cut here ]------------
> > > > list_add corruption. prev->next should be next (ffffffd6c7c5a6a8),
> > > >          but was ffffffc600a3bcc8. (prev=ffffffc600a3bcc8).
> > > > WARNING: lib/list_debug.c:32 at __list_add_valid_or_report+
> > > > 0xd8/0xe2, CPU#0: bash/466
> > > > Modules linked in: dwmac_starfive stmmac_platform stmmac pcs_xpcs phylink
> > > > CPU: 0 UID: 0 PID: 466 Comm: bash Tainted: G W 6.19.0-rc2+ #1 PREEMPTLAZY
> > > > Tainted: [W]=WARN
> > > > Hardware name: StarFive VisionFive 2 v1.3B (DT)
> > > >  epc : __list_add_valid_or_report+0xd8/0xe2
> > > >  ra : __list_add_valid_or_report+0xd8/0xe2
> > > >  epc : ffffffff80540bce ra : ffffffff80540bce sp : ffffffc600a3bc00
> > > >  gp : ffffffff81caec40 tp : ffffffd6c036f080 t0 : 0000000000000000
> > > >  t1 : 0000000000006000 t2 : 0000000000000002 s0 : ffffffc600a3bc30
> > > >  s1 : ffffffc600a3bcc8 a0 : ffffffd6fbf49a40 a1 : ffffffd6c036f080
> > > >  a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
> > > >  a5 : 0000000000000000 a6 : 0000000020000000 a7 : 0000000000000001
> > > >  s2 : ffffffd6c7c5a6a8 s3 : ffffffc600a3bcc8 s4 : ffffffc600a3bcc8
> > > >  s5 : ffffffd6c7c5a6b8 s6 : ffffffd6c7c5a6a8 s7 : 0000003ff3f32794
> > > >  s8 : 0000002ab38c9118 s9 : 0000000000000065 s10: 0000003f823a5cb8
> > > >  s11: 0000003f823264e8 t3 : 0000000000000001 t4 : 0000000000000000
> > > >  t5 : 00000000fa83b2da t6 : 000000000051df90
> > > > status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> > > > [<ffffffff80540bce>] __list_add_valid_or_report+0xd8/0xe2
> > > > [<ffffffff80255c86>] damon_call+0x52/0xe8
> > > > [<ffffffff8025c9a8>] damon_sysfs_damon_call+0x60/0x8a
> > > > [<ffffffff8025daf4>] state_store+0xfc/0x294
> > > > [<ffffffff80dbf1fa>] kobj_attr_store+0xe/0x1a
> > > > [<ffffffff802f070c>] sysfs_kf_write+0x42/0x56
> > > > [<ffffffff802eef4e>] kernfs_fop_write_iter+0xf4/0x178
> > > > [<ffffffff8026545c>] vfs_write+0x1b6/0x3b2
> > > > [<ffffffff80265782>] ksys_write+0x52/0xbc
> > > > [<ffffffff80265800>] __riscv_sys_write+0x14/0x1c
> > > > [<ffffffff80ddf124>] do_trap_ecall_u+0x19c/0x26e
> > > > [<ffffffff80deaa38>] handle_exception+0x150/0x15c
> > > > ---[ end trace 0000000000000000 ]---
> > > > -bash: echo: write error: Invalid argument
> > >
> > > Thank you for finding issue!
> > >
> > > Also appreciate for sharing your detailed reproducer.  Nevertheless, I think
> > > the reproducer can be more detailed.  E.g., you could explicitly explain the
> > > fact that the reproduction step should be executed only after starting DAMON
> > > with the kdamond, and the kernel should run with CONFIG_lIST_HARDENED to get
> > > the output from the kernel log.
> >
> > Yes, as you said, I ran it under CONFIG_LIST_HARDENED=y condition.
>
> Thank you for confirming.
>
> >
> > >
> > > >
> > > > The cause of the above error is that list_add_tail() is executed
> > > > repeatedly while executing damon_call(ctx, control)
> > > > in damon_sysfs_damon_call().  The execution flow is summarized below:
> > > >
> > > > damon_sysfs_damon_call()
> > > >         --> damon_call(ctx, control)
> > > >                 list_add_tail(control, ctx->call_contols);
> > > >                         --> /* list_add corruption error */
> > > >                 if (!damon_is_running)
> > > >                         return -EINVAL;
> > > >
> > > > If you execute damon_call() when damon_sysfs_kdamond_running() is true,
> > > > you can prevent the error of duplicate execution of list_add_tail().
> > >
> > > The kdamond might be terminated between the damon_call() call and the
> > > damon_is_running() check inside the damon_call() execution.  In the case, the
> > > problem may still happen.
> > >
> > > The problem happens because damon_call() is not removing the damon_call_control
> > > object before returning the error, right?  What about removing the object
> > > before returning the error?
> >
> > damon_call() is called after damon_start() --> kdamond_fn() is executed,
> > This is a problem because damon_call() also occurs when kdamond is "off"
> > only in damon/sysfs.  So, my first patch solved the problem, but the
> > following also worked. I tested it.
> >
> > And it seems better to keep the existing method of releasing
> > damon_call_control.  Since the damon_call_control structure uses both
> > static and kmalloc(),  it's appropriate to release it in kdamond_fn() according
> > to the condition control->canceled && control->dealloc_on_cancel.
> >
> > My previous suggestion regarding this:
> > https://lore.kernel.org/damon/20251206224724.13832-1-rgbi3307@gmail.com/
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index babad37719b6..2ead0bb3c462 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> >   */
> >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> >  {
> > +       if (!damon_is_running(ctx))
> > +               return -EINVAL;
> > +
> >         if (!control->repeat)
> >                 init_completion(&control->completion);
> >         control->canceled = false;
> > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         mutex_lock(&ctx->call_controls_lock);
> >         list_add_tail(&control->list, &ctx->call_controls);
> >         mutex_unlock(&ctx->call_controls_lock);
> > -       if (!damon_is_running(ctx))
> > -               return -EINVAL;
> >         if (control->repeat)
> >                 return 0;
> >         wait_for_completion(&control->completion);
>
> Let's assume DAMON is terminated between the damon_is_running() and
> list_add_tail().  In the case, the control->fn() will never be called back.  If
> control->repeat is false, this function will even inifnitely wait.

As you said, there are cases where kdamond is terminated(stopped) in
damon_is_running() and list_add_tail().  It may be a very rare case, but
I missed this case.

>
> I think we should keep the damon_is_running() as is, but further check if it
> was terminated without handling the control object, and remove it from the list
> in the case.  Like below.
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index c3ae55b940cc..23d8602f5a49 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1649,6 +1649,35 @@ bool damon_is_running(struct damon_ctx *ctx)
>         return running;
>  }
>
> +/*
> + * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
> + *                                   an inactive context.
> + * @ctx:       The inactive DAMON context.
> + * @control:   Control variable of the call request.
> + *
> + * This function is called in a case that @control is added to @ctx but @ctx is
> + * not running (inactive).  See if @ctx handled @control or not, and cleanup
> + * @control if it was not handled.
> + *
> + * Returns 0 if @control was handled by @ctx, negative error code otherwise.
> + */
> +static int damon_call_handle_inactive_ctx(
> +               struct damon_ctx *ctx, struct damon_call_control *control)
> +{
> +       struct damon_call_control *c;
> +
> +       mutex_lock(&ctx->call_controls_lock);
> +       list_for_each_entry(c, &ctx->call_controls, list) {
> +               if (c == control) {
> +                       list_del(&control->list);
> +                       mutex_unlock(&ctx->call_controls_lock);
> +                       return -EINVAL;
> +               }
> +       }
> +       mutex_unlock(&ctx->call_controls_lock);
> +       return 0;
> +}
> +
>  /**
>   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
>   * @ctx:       DAMON context to call the function for.
> @@ -1679,7 +1708,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>         list_add_tail(&control->list, &ctx->call_controls);
>         mutex_unlock(&ctx->call_controls_lock);
>         if (!damon_is_running(ctx))
> -               return -EINVAL;
> +               return damon_call_handle_inactive_ctx(ctx, control);
>         if (control->repeat)
>                 return 0;
>         wait_for_completion(&control->completion);
>

However, the damon_call_handle_inactive_ctx() function is to post-process
the duplicate addition of control->list.  Rather, it is more efficient to
prevent duplicate additions in advance, as follows:
I have tested the following and it works fine.

@@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        control->canceled = false;
        INIT_LIST_HEAD(&control->list);

-       mutex_lock(&ctx->call_controls_lock);
-       list_add_tail(&control->list, &ctx->call_controls);
-       mutex_unlock(&ctx->call_controls_lock);
-       if (!damon_is_running(ctx))
+       if (damon_is_running(ctx)) {
+               mutex_lock(&ctx->call_controls_lock);
+               list_add_tail(&control->list, &ctx->call_controls);
+               mutex_unlock(&ctx->call_controls_lock);
+       } else {
+               /* return damon_call_handle_inactive_ctx(ctx, control); */
                return -EINVAL;
+       }
        if (control->repeat)
                return 0;
        wait_for_completion(&control->completion);

> If you don't mind, I'll post the above diff as a patch, adding a 'Reported-by:'
> tag for you.

'Reported-by:' is OK.  However, please check the above again.

>
> >
> > >
> > > >
> > > > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > >
> > > Could you please also add Fixes: and Cc: stable@ ?
> >
> > I don't have much experience with this, so I'm sorry,
> > but could you please give me an example about this?
>
> No problem.
>
> Please refer to https://docs.kernel.org/process/stable-kernel-rules.html

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

