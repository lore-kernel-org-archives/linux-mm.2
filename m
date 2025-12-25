Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8F8E784BB
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463A66B008C; Wed, 24 Dec 2025 21:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410EA6B0092; Wed, 24 Dec 2025 21:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2E06B0098; Wed, 24 Dec 2025 21:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE376B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:35:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFB858B721
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:35:47 +0000 (UTC)
X-FDA: 84256427934.08.BEC4AB2
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0153940003
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:35:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCW4N789;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766630146; a=rsa-sha256;
	cv=none;
	b=dv9/MoYC0GPo/Ltkgz/lZt+aL61kptn+MqvJybD/b1H73xmn3wu5CqOzF7EkoriMryNIkP
	fXF0k6k+YviOrXlKsbLadW5AIYsJ6lkc6fe1WSNBSmr2e6ZhTr8gkSbvXCdA9tTJIEbHa9
	HdHbGXvvBqN6lcaGuM32S/FQ4reSF8s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCW4N789;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766630146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k058UDgg3LCnjnLtE2FrkVFFN7BHHlc8PNQkuIVP+vA=;
	b=3YxeYB2qe4LkcIJb0eZgTilYgoMpQOxxa1H/lw+lYA9Zde3JUECdA/dA/j+dbB6l5YmgeG
	FcvSpxFXQr2ROuf3Q4VUBqO5YGTwg45bMHP9OPipp0cmPBTbLzbddQjh9DPUmotGT2r7CS
	LVk9OYQEXTsd7E76XuhU8SopX85AG0M=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64476c85854so5684007d50.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 18:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766630145; x=1767234945; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k058UDgg3LCnjnLtE2FrkVFFN7BHHlc8PNQkuIVP+vA=;
        b=YCW4N789gyTiI7LiHBemBbJSv0kgqD/ejn1bWSxAyi/JujqbyZmau+I0TxLjq6AZA9
         hpO95zCrOIPS+MVVSKh8C3g4RunA743IDyiYy7TcWXfNepoq9e4pWVGhrm3mpW79wRzN
         TnZj9woIJlW8cSesjDJo2sjxyUKD+wamEIjav17aA7KeRM0xYyU38mxOjzUqMAVKceXD
         KhIUXWEsEnSN6K2Cr+ShnoxY8tYIT7fg/OIOJbRnR9Vy/fIupfIdyhBaki6QSR7Yp5A6
         QnYqNH/0cCDL4TqfJV5goymvv4ULlH2oYHiKGv6PH5uav1lB/CdxxIacBnRpB1yxQ7wz
         xxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766630145; x=1767234945;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k058UDgg3LCnjnLtE2FrkVFFN7BHHlc8PNQkuIVP+vA=;
        b=pNt+t5arfQlKuyGcwXASe7kXcQYeCfy/9Xga+GE067iZfvdET4+9ZYUJzAIp2Y7JjT
         lOAdN+jB680pfCBM27eCA+Jj9xFFfRRb/yjZaCPb40F6tvlq2WTkx1s3ho13+eV9UHfX
         u8g3k943nTi3UDEqJ0U7kaOQibJHvs4FtrYs5OUKypiQzKIgUvaqBsZumuCfwesM0GWX
         Q+znDi1Fzd/ZsC06eI09h0gbnYz95ytLMoHxIZEyQAYnMkCr3n0X2C0jEQBF5WIzOItI
         hmauk3hJ8RZvFgercTb/vkK+EE7W01iGLxTNrY4mTVWRVyodvXCrV82QzwdzBWYPxxmb
         rylQ==
X-Forwarded-Encrypted: i=1; AJvYcCXju3p4I/estUGCOYYs2mY9d9avh8KBT74480N/PZOmyG8ESfzSa7QpoVuEs0utqIBcdXhzyAZh/w==@kvack.org
X-Gm-Message-State: AOJu0YzZZ9y5ixF2bkmy395PUjHc7fowcX+KZZUXrmZagw4/vE9BckK6
	6s0CXs0ztsALueXxVudZ3HAhGvSg7WkuP4cr0M498kM55uk6+1Gcx6aFbHUbDVSHKf98Cq/pEFH
	uYNJcZ3XJ5Ayt4PA4W28qqrMr/jsizMw=
X-Gm-Gg: AY/fxX4mfsp8CsPmhcfC8xqf9G/c3/auQGyZO4PixmEAwRQLss22U/OxmeD+4UZikS5
	5NtgF/5N/RyYC3yj2aduXE5HoGopyFiYur449iaWygjs15y0pENU/7g3BNy12liJEay9/iOdPEF
	UIL8xjL7XhrLY8txA3nOTueZhUEMwPmGvE+tK6Btm5gCjkPqaWqgQvbyguD/X0IIxkpUFuuV37W
	RMHSozVWT9nYPXj1FRwGerJEV3C88nncO3X8WaCHmQqGOH8DV8EUFu89+/tXLutebdMf1f5AuBU
	wGSK2/8=
X-Google-Smtp-Source: AGHT+IEODZJc0vqbVAwJDOlW779gyJCua0TNMgVvZw14eqfWceSCnIhnO2ONJlqeIRc/TtCmXF/8Cu1NaQboQcjJLpE=
X-Received: by 2002:a05:690c:4c04:b0:78e:3dcf:7aac with SMTP id
 00721157ae682-78fb3f4fdcfmr342775117b3.22.1766630144878; Wed, 24 Dec 2025
 18:35:44 -0800 (PST)
MIME-Version: 1.0
References: <20251224094401.20384-1-rgbi3307@gmail.com> <20251225003205.14522-1-sj@kernel.org>
In-Reply-To: <20251225003205.14522-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 25 Dec 2025 11:35:33 +0900
X-Gm-Features: AQt7F2oFkL6Fz1e8PUNo6G3DsBuv1kfHmf4SmplDmSqS-zaXm2g2R20u1oB0lGE
Message-ID: <CAHOvCC4zwbiLXRTHav67GcngiVZ-5GESqkY9juLtqAfWQW1UQg@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at
 the damon_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0153940003
X-Rspamd-Server: rspam10
X-Stat-Signature: 8r5q43dt68uxcs8y1n6w57yr6tq4t6cj
X-HE-Tag: 1766630145-875339
X-HE-Meta: U2FsdGVkX18rmiZ5Kx2JYkRDz4BRxhUdxyQ2jXahjILHVl3ZdCsM5weEwXR/Lt4w0ogo3cqHTxvfXLaBb7vetC2YOTdRi06PtAEw6h/ZHPkUbUrcVfd+Rt8ZB9OR9PKGYgA8+xN+chZNM2SU6aKcg5F9Bl9nAaEII0fhuysEyj5lyX1iDJhoLzIXDSRMM5LBsUSmRfxT0J7KsTMsnVBkMBYklfaPYLUJgm8RCLHSnZQtaqTLHpQB2YXhW9ht+TXqhtZTQl/g3lDayCVwVhyZjbPw76KDTGtbJ6Wtnb/di+NAzE9rjt5EGxh9O2MDxFxcc4vSMVKng9oqTFNxgA0zzVBPKy0yiaNDnFldopNTeRr3OFdQRtzOwoUcb4xN1+2dxegIgMMmXXWMmqpaSgzqxZBdkPgD+zXOJvOW0oxHqWMM6FvBtkU3Wa4kDvPatMYuMwljwz2gZXhD9WX3Rg0vERbr4bqooYFrdL/VV49JSysbJjTn568qQLqbjhc5ouRsujH+/0U4nAAI3KDBuwJiegi9uir9fdFZ05Cippvcqg2TVLJZdCoQ/k9qQWMBGtP0NjPl4A5s5XfoBigX0/9qVUtvfoplCBSTZmbmvHu2KatYLW5x/4sXt8VZNY0A9TxMXJqQRqM+sU+BbqfzARkX1hSNzRokQ5k25X0ev6qVYA1CXeXXAoVvUnaHHDiPtlZLE0uN5eEeWiJ08FUrC4N8hnkCkwCC+CGtUPGIUbjIHYWRXp9vyXHNonQkX8yb89x1EfRA84oBzOYf3EC2Fba66pPRGXqjl40in0wJlMSbtAE6dITMmx+s3tndb3RnOg2/RHV6eHICxrQqPMFnaI+Jxstm38D94E0og7TrCcEdm6nSStK4hlEaTBT0eB1wolIHa3kD3BKWckZ6FaYCUzJ4NbX6fDyBscICtEgnUNXGCMxFhRrx/d7qRJq3g7GvPHS4b4WjC/ecSqnuprbpKcg
 WryqFaRK
 UCgsKuD5+5i22UBxnHY5SKA3PPRdty/qkQENhQkls0Paguuud2P0KeKu3aIHe8+718pHgWSyZBy9/N/MO3x0oZY9BKPFjxZe/AJu283P9VLEHgMn2t5YLzay4dtwjxr0xEKxSoyJY9UlQ/rDYd456vbpXqTuNwL8BuSknoBK4rdGtITypN1sAgyYr/Lq0p2f9bsbpQLVU8UNLt4qwXlXlWPVHYuI1HcCf4NJZUVrpxnvXuQ15GXurKRu1sS2TA/F/noaJCzsoJktX0MiScCKgpdIznbe1xR0SKTK3Y44llQKxVBvqED+v0JIRLt3NGeIy+r7FpnFyPSSb3Krft+KcAWEQAuDdgaOwq3E79FTXBtiOrlsxX01Kss/4p86jYUK2kR6GrWD4mK26VB0NLoXMlYWA7DsG08Y3Mqj1KzndcM2bzsnO4YKToiO6OHBqMqccp1mD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
>
> Hello JaeJoon,
>
> On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> >  cd /sys/kernel/mm/damon/admin
> >  echo "off" > kdamonds/0/state
> >
> >  echo "commit" > kdamonds/0/state
> >  echo "commit" > kdamonds/0/state
> >
> > If you repeat "commit" twice with the kdamonds/0/state set to "off"
> > with the above command, list_add corruption error occurs as follows:
> >
> > 4-page vmalloc region starting at 0xffffffc600a38000 allocated at
> > kernel_clone+0x44/0x41e
> > ------------[ cut here ]------------
> > list_add corruption. prev->next should be next (ffffffd6c7c5a6a8),
> >          but was ffffffc600a3bcc8. (prev=ffffffc600a3bcc8).
> > WARNING: lib/list_debug.c:32 at __list_add_valid_or_report+
> > 0xd8/0xe2, CPU#0: bash/466
> > Modules linked in: dwmac_starfive stmmac_platform stmmac pcs_xpcs phylink
> > CPU: 0 UID: 0 PID: 466 Comm: bash Tainted: G W 6.19.0-rc2+ #1 PREEMPTLAZY
> > Tainted: [W]=WARN
> > Hardware name: StarFive VisionFive 2 v1.3B (DT)
> >  epc : __list_add_valid_or_report+0xd8/0xe2
> >  ra : __list_add_valid_or_report+0xd8/0xe2
> >  epc : ffffffff80540bce ra : ffffffff80540bce sp : ffffffc600a3bc00
> >  gp : ffffffff81caec40 tp : ffffffd6c036f080 t0 : 0000000000000000
> >  t1 : 0000000000006000 t2 : 0000000000000002 s0 : ffffffc600a3bc30
> >  s1 : ffffffc600a3bcc8 a0 : ffffffd6fbf49a40 a1 : ffffffd6c036f080
> >  a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
> >  a5 : 0000000000000000 a6 : 0000000020000000 a7 : 0000000000000001
> >  s2 : ffffffd6c7c5a6a8 s3 : ffffffc600a3bcc8 s4 : ffffffc600a3bcc8
> >  s5 : ffffffd6c7c5a6b8 s6 : ffffffd6c7c5a6a8 s7 : 0000003ff3f32794
> >  s8 : 0000002ab38c9118 s9 : 0000000000000065 s10: 0000003f823a5cb8
> >  s11: 0000003f823264e8 t3 : 0000000000000001 t4 : 0000000000000000
> >  t5 : 00000000fa83b2da t6 : 000000000051df90
> > status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> > [<ffffffff80540bce>] __list_add_valid_or_report+0xd8/0xe2
> > [<ffffffff80255c86>] damon_call+0x52/0xe8
> > [<ffffffff8025c9a8>] damon_sysfs_damon_call+0x60/0x8a
> > [<ffffffff8025daf4>] state_store+0xfc/0x294
> > [<ffffffff80dbf1fa>] kobj_attr_store+0xe/0x1a
> > [<ffffffff802f070c>] sysfs_kf_write+0x42/0x56
> > [<ffffffff802eef4e>] kernfs_fop_write_iter+0xf4/0x178
> > [<ffffffff8026545c>] vfs_write+0x1b6/0x3b2
> > [<ffffffff80265782>] ksys_write+0x52/0xbc
> > [<ffffffff80265800>] __riscv_sys_write+0x14/0x1c
> > [<ffffffff80ddf124>] do_trap_ecall_u+0x19c/0x26e
> > [<ffffffff80deaa38>] handle_exception+0x150/0x15c
> > ---[ end trace 0000000000000000 ]---
> > -bash: echo: write error: Invalid argument
>
> Thank you for finding issue!
>
> Also appreciate for sharing your detailed reproducer.  Nevertheless, I think
> the reproducer can be more detailed.  E.g., you could explicitly explain the
> fact that the reproduction step should be executed only after starting DAMON
> with the kdamond, and the kernel should run with CONFIG_lIST_HARDENED to get
> the output from the kernel log.

Yes, as you said, I ran it under CONFIG_LIST_HARDENED=y condition.

>
> >
> > The cause of the above error is that list_add_tail() is executed
> > repeatedly while executing damon_call(ctx, control)
> > in damon_sysfs_damon_call().  The execution flow is summarized below:
> >
> > damon_sysfs_damon_call()
> >         --> damon_call(ctx, control)
> >                 list_add_tail(control, ctx->call_contols);
> >                         --> /* list_add corruption error */
> >                 if (!damon_is_running)
> >                         return -EINVAL;
> >
> > If you execute damon_call() when damon_sysfs_kdamond_running() is true,
> > you can prevent the error of duplicate execution of list_add_tail().
>
> The kdamond might be terminated between the damon_call() call and the
> damon_is_running() check inside the damon_call() execution.  In the case, the
> problem may still happen.
>
> The problem happens because damon_call() is not removing the damon_call_control
> object before returning the error, right?  What about removing the object
> before returning the error?

damon_call() is called after damon_start() --> kdamond_fn() is executed,
This is a problem because damon_call() also occurs when kdamond is "off"
only in damon/sysfs.  So, my first patch solved the problem, but the
following also worked. I tested it.

And it seems better to keep the existing method of releasing
damon_call_control.  Since the damon_call_control structure uses both
static and kmalloc(),  it's appropriate to release it in kdamond_fn() according
to the condition control->canceled && control->dealloc_on_cancel.

My previous suggestion regarding this:
https://lore.kernel.org/damon/20251206224724.13832-1-rgbi3307@gmail.com/

diff --git a/mm/damon/core.c b/mm/damon/core.c
index babad37719b6..2ead0bb3c462 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
+       if (!damon_is_running(ctx))
+               return -EINVAL;
+
        if (!control->repeat)
                init_completion(&control->completion);
        control->canceled = false;
@@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        mutex_lock(&ctx->call_controls_lock);
        list_add_tail(&control->list, &ctx->call_controls);
        mutex_unlock(&ctx->call_controls_lock);
-       if (!damon_is_running(ctx))
-               return -EINVAL;
        if (control->repeat)
                return 0;
        wait_for_completion(&control->completion);

>
> >
> > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
>
> Could you please also add Fixes: and Cc: stable@ ?

I don't have much experience with this, so I'm sorry,
but could you please give me an example about this?

>
>
> Thanks,
> SJ
>
> [...]

